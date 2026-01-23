package com.smartcity.chat.service;

import com.smartcity.chat.mapper.EnablingPlatformMapper;
import com.smartcity.chat.model.EnablingPlatform;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SimpleVectorStore;
import org.springframework.ai.vectorstore.VectorStore; 
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class VectorSyncService {

    private final EnablingPlatformMapper platformMapper;
    private final VectorStore vectorStore;

    // 向量库文件持久化路径
    @Value("${smart-chat.vector-store.path:./data/vector_store.json}")
    private String vectorStorePath;

    // 记录上次同步的时间，用于实现增量同步，减少重复的 Embedding 调用
    private java.time.LocalDateTime lastSyncTime = null;
    
    /**
     * 定时任务：同步数据库商品数据到向量库。
     * initialDelay = 10000: 项目启动 10 秒后执行第一次，确保其他组件已完全就绪。
     * fixedRate = 300000: 每 5 分钟执行一次，保持数据同步。
     */
    @Scheduled(initialDelay = 10000, fixedRate = 300000) 
    public void syncDataToVectorStore() {
        log.info("Checking for product updates to sync with vector store...");
        
        // 1. 获取需要检查的候选商品列表
        List<EnablingPlatform> products;
        if (lastSyncTime == null) {
            // 场景：项目刚启动时的第一次同步
            File file = new File(vectorStorePath);
            if (file.exists()) {
                // 如果本地已存在向量库文件，说明基础数据已经存在。
                // 我们直接设置 lastSyncTime 为当前时间，接下来的定时任务将只同步“从现在起”产生变化的商品。
                // 这样避免了每次重启都要把几百个商品全都发给阿里重新计算一遍向量（耗时且费钱）。
                log.info("Vector store file exists. Skipping redundant full sync on startup.");
                lastSyncTime = java.time.LocalDateTime.now();
                return;
            } else {
                // 如果文件不存在，则需要全量抓取数据库数据进行初始化同步
                products = platformMapper.selectByStatus(0);
                log.info("No vector store file found. Performing full initial sync with {} products.", products.size());
            }
        } else {
            // 场景：正常的增量同步运行
            // 获取所有上架状态的商品，稍后在内存中过滤有变动的
            products = platformMapper.selectByStatus(0);
        }
        
        if (products.isEmpty()) {
            lastSyncTime = java.time.LocalDateTime.now();
            return;
        }

        // 2. 核心增量逻辑：过滤出在上次同步时间之后被创建或更新过的商品
        List<Document> documentsToUpdate = products.stream()
                .filter(p -> {
                    // 如果是全量初始化状态，则全部通过
                    if (lastSyncTime == null) return true;
                    // 获取商品的最终变动时间（有更新时间取更新时间，否则取添加时间）
                    java.time.LocalDateTime uptime = p.getUpdateTime() != null ? p.getUpdateTime() : p.getAddTime();
                    // 只处理在上次同步时间之后的变动
                    return uptime != null && uptime.isAfter(lastSyncTime);
                })
                .map(this::convertToDocument)
                .collect(Collectors.toList());

        if (documentsToUpdate.isEmpty()) {
            // 如果没有检测到任何变动，则直接结束，并更新同步时间
            log.info("No new or updated products detected.");
            lastSyncTime = java.time.LocalDateTime.now();
            return;
        }

        log.info("Detected {} changed products. Updating vectors...", documentsToUpdate.size());

        // 3. 将新版商品 Document 集体存入向量库（内部会覆盖旧 ID 对应的向量）
        vectorStore.add(documentsToUpdate);
        lastSyncTime = java.time.LocalDateTime.now();

        // 4. 持久化存储：将最新的向量库快照写入 JSON 文件，以便下次启动直接载入
        if (vectorStore instanceof SimpleVectorStore) {
            File file = new File(vectorStorePath);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
            ((SimpleVectorStore) vectorStore).save(file);
        }

        log.info("Vector incremental sync completed.");
    }

    /**
     * 将数据库实体转换为 Spring AI 的 Document。
     * 关键优化：将 ID、名称、行业和详情拼接为文本，供 Embedding 模型计算语义向量。
     */
    private Document convertToDocument(EnablingPlatform p) {
        // 重大修复：必须将商品ID包含在 Searchable Content 中，
        // 否则 AI 无法从检索片段中提取原始 ID，容易导致 ID 幻觉（乱编一个 ID）。
        String content = String.format("商品ID: %s\n商品名称: %s\n类型: %s\n行业: %s\n链接: %s\n账号: %s\n密码: %s\n介绍: %s", 
                p.getMdseId(), p.getMdseName(), p.getMdseType(), p.getIndustryType(), 
                formatLink(p.getMdseLink()),
                p.getMdseAccount() != null ? p.getMdseAccount() : "暂无",
                p.getMdsePassword() != null ? p.getMdsePassword() : "暂无",
                p.getMdseIntro());

        // 元数据保存，用于后续 UI 展示或过滤
        Map<String, Object> metadata = Map.of(
            "id", p.getMdseId(),
            "name", p.getMdseName(),
            "link", formatLink(p.getMdseLink()),
            "price", p.getMdsePrice() != null ? p.getMdsePrice() : 0.0,
            "logo", p.getMdsePecificLogo() != null ? p.getMdsePecificLogo() : ""
        );

        return new Document(p.getMdseId(), content, metadata);
    }

    private String formatLink(String link) {
        if (link == null || link.trim().isEmpty() || "暂无".equals(link)) {
            return "暂无";
        }
        String trimmed = link.trim();
        if (!trimmed.startsWith("http://") && !trimmed.startsWith("https://")) {
            return "http://" + trimmed;
        }
        return trimmed;
    }
}
