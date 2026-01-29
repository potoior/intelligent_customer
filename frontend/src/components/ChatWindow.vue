<template>
  <div class="chat-window pc-layout">
    <!-- 左侧导航栏 (PC端专属) -->
    <div class="chat-sidebar">
      <div class="sidebar-header">
        <div class="sidebar-logo">
          <span class="logo-icon">💠</span>
          <span class="logo-text" style="font-size: 18px;">智能对话与客服系统</span>
        </div>
        <div class="user-profile">
          <div class="mini-avatar">👤</div>
          <span>客服</span>
        </div>
      </div>
    </div>

    <!-- 右侧聊天主区域 -->
    <div class="chat-main">
      <div class="chat-header">
        <h3>智能客服助手</h3>
        <div class="header-actions">
           <el-tag size="small" type="success" effect="dark">在线</el-tag>
           <el-button type="text" size="small" style="margin-left:10px" @click="clearMessages">清空对话</el-button>
        </div>
      </div>
    
    <div class="messages-container" ref="messagesRef">
      <div v-for="(msg, index) in messages" :key="index" :class="['message-row', msg.role === 'user' ? 'user-row' : 'assistant-row']">
        <!-- 头像 -->
        <div class="avatar" v-if="msg.role === 'assistant'">🤖</div>
        
        <div class="message-content">
          <!-- 文本消息 -->
          <div v-if="msg.type === 'text'" class="text-bubble" v-html="renderMarkdown(msg.content)"></div>
          
          <!-- 预约卡片组件 (AI 触发) -->
          <AppointmentCard 
            v-if="msg.type === 'reservation_card'" 
            :product-data="msg.data"
            @submitted="handleCardSubmitted(index)"
            @cancelled="removeMessage(index)"
          />
        </div>

        <div class="avatar" v-if="msg.role === 'user'">👤</div>
      </div>
      
      <!-- Loading Indicator -->
      <div v-if="isThinking" class="message-row assistant-row">
        <div class="avatar">🤖</div>
        <div class="text-bubble thinking">
          <span class="dot">.</span><span class="dot">.</span><span class="dot">.</span>
        </div>
      </div>
    </div>

      <div class="input-area">
        <el-input 
          v-model="inputMessage" 
          placeholder="请输入您的问题，例如：我想了解物流系统..." 
          @keyup.enter="sendMessage"
          size="large"
          :disabled="isThinking"
          :rows="3"
          type="textarea"
          resize="none"
        >
          <template #append>
            <el-button 
              @click="sendMessage" 
              type="primary" 
              :loading="isThinking"
              size="large"
              style="height: 100%; min-height: 80px; border-radius: 0 8px 8px 0;"
            >
              <el-icon style="margin-right: 4px;"><Promotion /></el-icon>
              发送咨询
            </el-button>
          </template>
        </el-input>
        <div class="input-tip">按 Enter 发送消息，Shift + Enter 换行</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick, onUpdated } from 'vue'
import { marked } from 'marked'
import AppointmentCard from './AppointmentCard.vue'
import { fetchEventSource } from '@microsoft/fetch-event-source' // Or use native fetch
import { Promotion } from '@element-plus/icons-vue'

const messages = ref([
  { role: 'assistant', type: 'text', content: '您好！我是您的智能客服助手。请问有什么可以帮您？' }
])
const inputMessage = ref('')
const isThinking = ref(false)
const messagesRef = ref(null)

// 配置 marked 渲染选项
marked.setOptions({
  breaks: true, // 支持单换行符转为 <br>
  gfm: true,    // 支持 GitHub 风格的 Markdown
  pedantic: false, // 尽可能兼容非规范语法
  smartypants: true // 优化引号等符号展示
})

const renderMarkdown = (text) => {
  // 打印原始文本以便调试渲染问题（仅在开发环境查看）
  // console.log('Raw text for markdown:', text)
  return marked.parse(text || '')
}

const scrollToBottom = () => {
  nextTick(() => {
    if (messagesRef.value) {
      messagesRef.value.scrollTop = messagesRef.value.scrollHeight
    }
  })
}

// 监听 Function Call 的特殊标记
// 假设后端在 SSE 流中，会以特殊格式下发指令，或者我们在前端匹配文本
// 简单起见，我们这里假设后端会在文本块中包含 JSON 标记，或者前端做正则匹配
// 更好的做法是后端 SSE 事件类型不同，这里为了演示，我们在 JS 里做文本匹配
/**
 * 意图识别与卡片触发器
 * 逻辑：在流式输出的回复中，通过正则表达式实时检测特定的 JSON 指令块。
 */
const detectReservationIntent = (text) => {
  // 正则说明：匹配以 ```json (可选) 开头，包含 __action__: SHOW_RESERVATION_CARD 的块
  // s 修饰符允许 . 匹配换行符
  const regex = /(?:```json\s*)?({.*?"__action__":\s*"SHOW_RESERVATION_CARD".*?})(?:\s*```)?/s
  const match = text.match(regex)
  
  if (match) {
    try {
      // 检查匹配到的 JSON 字符串是否已闭合
      const jsonStr = match[1].trim()
      if (!jsonStr.endsWith('}')) return null
      
      // 解析 JSON 载荷（包含商品名、ID 等）
      const data = JSON.parse(jsonStr)
      return data
    } catch (e) {
      // 如果报错，通常说明流式输出还没传完（JSON 本身也可能被切断），忽略并等待下次包
      return null
    }
  }
  return null
}

const sendMessage = async () => {
  const text = inputMessage.value.trim()
  if (!text) return

  messages.value.push({ role: 'user', type: 'text', content: text })
  inputMessage.value = ''
  isThinking.value = true
  scrollToBottom()

  const assistantMsgIndex = messages.value.push({ role: 'assistant', type: 'text', content: '' }) - 1
  let fullContent = ''

  try {
    const response = await fetch('http://120.76.218.38:9533/api/chat/stream', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            message: text,
            // 过滤历史消息，只发送文本内容，且排除掉刚刚 push 进去的最新的 user 消息和空的 assistant 消息
            history: messages.value
                .slice(0, -2) // 排除掉最后两个（刚刚 push 的 user 和空的 assistant）
                .filter(m => m.type === 'text' && m.content)
                .map(m => ({ role: m.role, content: m.content }))
        })
    })

    const reader = response.body.getReader()
    const decoder = new TextDecoder()
    // 关键优化：引入缓冲区 buffer，用于处理跨包乱码和碎片行
    let buffer = ''

    while (true) {
        const { done, value } = await reader.read()
        if (done) break
        
        // 核心技术点：stream: true 告诉解码器当前字节流仍在继续，
        // 这样即使一个汉字的 3 个字节分属不同的网络包，解码器也能正确拼合，不会产生回音或乱码。
        buffer += decoder.decode(value, { stream: true })
        
        // 按行切割数据，因为 SSE 规范是以 \n 分隔的一行行 data:
        let lines = buffer.split('\n')
        // 最后一行可能是“半行”，保留在 buffer 中等待下一个网络包传全
        buffer = lines.pop() || ''
        
        for (const line of lines) {
            const trimmedLine = line.trim()
            if (trimmedLine.startsWith('data:')) {
                // 标准格式：data: 内容
                // 去掉 data: 前缀，如果后面带空格也一并去掉
                let content = trimmedLine.substring(5)
                if (content.startsWith(' ')) {
                    content = content.substring(1)
                }
                fullContent += content
                // 实时更新当前消息的 UI 内容，实现“一个字一个字蹦出来”的效果
                messages.value[assistantMsgIndex].content = fullContent
                
                // 实时检测回复中是否包含了触发预约卡片的 JSON 指令
                const actionData = detectReservationIntent(fullContent)
                if (actionData) {
                    // 找到了预约意图！从显示的文本中移除这段 JSON 块（对终端用户不可见）
                    messages.value[assistantMsgIndex].content = fullContent.replace(/(?:```json\s*)?{.*?"__action__":\s*"SHOW_RESERVATION_CARD".*?}(?:\s*```)?/s, '')
                    
                    // 为了防止在流式更新中重复生成卡片，检查最后一条消息是否已经是该卡片
                    const lastMsg = messages.value[messages.value.length - 1]
                    if (lastMsg.type !== 'reservation_card') {
                         messages.value.push({ 
                            role: 'assistant', 
                            type: 'reservation_card', 
                            data: actionData 
                        })
                    }
                }
                
                scrollToBottom()
            }
        }
    }
    
    // 流结束后的补漏：处理 buffer 中剩余的扫尾数据
    const finalTrimmed = buffer.trim()
    if (finalTrimmed.startsWith('data:')) {
        let content = finalTrimmed.substring(5)
        if (content.startsWith(' ')) content = content.substring(1)
        fullContent += content
        messages.value[assistantMsgIndex].content = fullContent
    }
  } catch (e) {
    console.error(e)
    messages.value[assistantMsgIndex].content += '\n[连接服务器失败...]'
  } finally {
    isThinking.value = false
  }
}

const clearMessages = () => {
  messages.value = [
    { role: 'assistant', type: 'text', content: '会话已清空。请问您还有什么需要了解的吗？' }
  ]
}

const handleCardSubmitted = (index) => {
   // 提交后，把卡片变成“已提交”状态，或者增加一条系统消息
   messages.value.push({ role: 'assistant', type: 'text', content: '✅ 您的预约已提交，我们会尽快联系您。' })
   scrollToBottom()
}

const removeMessage = (index) => {
    messages.value.splice(index, 1)
}

onUpdated(scrollToBottom)
</script>

<style scoped>
.chat-window {
  width: 100vw;
  height: 100vh;
  background: #fff;
  display: flex;
  flex-direction: row;
  overflow: hidden;
  text-align: left;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

/* 侧边栏样式 */
.chat-sidebar {
  width: 280px;
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  display: flex;
  flex-direction: column;
  color: #fff;
  padding: 0;
  box-shadow: 2px 0 10px rgba(0,0,0,0.1);
  height: 100vh;
  justify-content: space-between;
}
.sidebar-header {
  padding: 20px 25px;
  display: flex;
  flex-direction: column;
  gap: 30px;
  align-items: center;
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 12px;
}
.logo-icon { font-size: 28px; }
.logo-text { font-size: 20px; font-weight: 600; letter-spacing: 0.5px; }



.user-profile { 
  display: flex; 
  align-items: center; 
  gap: 12px; 
  font-size: 14px; 
  padding: 20px 25px;
  border-top: 1px solid rgba(255,255,255,0.1);
  width: 100%;
  justify-content: center;
  background: rgba(255,255,255,0.05);
}
.mini-avatar { 
  width: 32px; 
  height: 32px; 
  background: linear-gradient(135deg, #5d6d7e, #4a5a6b); 
  border-radius: 50%; 
  display: flex; 
  align-items: center; 
  justify-content: center;
  font-size: 16px;
}

/* 主聊天区域 */
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #fff;
}

.chat-header {
  padding: 20px 40px;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #fafbfc, #f5f7fa);
  height: 70px;
  box-sizing: border-box;
}
.chat-header h3 {
  margin: 0;
  font-weight: 600;
  color: #303133;
  font-size: 20px;
}
.header-actions {
  display: flex;
  align-items: center;
}
.messages-container {
  flex: 1;
  padding: 40px 60px; /* PC端更大的边距 */
  overflow-y: auto;
  background: linear-gradient(135deg, #fdfdfe 0%, #f8fafc 100%);
  max-width: 1200px;
  margin: 0 auto;
}
/* 美化滚动条 */
.messages-container::-webkit-scrollbar {
  width: 6px;
}
.messages-container::-webkit-scrollbar-thumb {
  background: #e0e0e0;
  border-radius: 10px;
}
.messages-container::-webkit-scrollbar-track {
  background: transparent;
}
.message-row {
  display: flex;
  margin-bottom: 20px;
  align-items: flex-start;
}
.user-row {
  flex-direction: row;
  justify-content: flex-end;
  transition: all 0.3s ease;
}
.assistant-row {
  flex-direction: row;
  justify-content: flex-start;
  transition: all 0.3s ease;
}
.avatar {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: #e1f3d8;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 12px;
  font-size: 22px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  flex-shrink: 0;
}
.user-row .avatar {
  background: #d9ecff;
}
.message-content {
  max-width: 65%;
}
.user-row .message-content {
  max-width: 70%;
}
.text-bubble {
  background: #fff;
  padding: 16px 22px;
  border-radius: 8px 20px 20px 20px;
  box-shadow: 0 6px 20px rgba(0,0,0,0.08);
  line-height: 1.7;
  font-size: 15px;
  color: #3c4043;
  border: 1px solid #f0f0f0;
}
.user-row .text-bubble {
  background: linear-gradient(135deg, #409eff, #1d82e6);
  color: #fff;
  border-radius: 20px 8px 20px 20px;
  border: none;
}

/* Markdown 内部元素深度渲染 */
.text-bubble :deep(p) {
  margin: 0 0 16px 0;
  font-size: 15px;
  line-height: 1.7;
}
.text-bubble :deep(p):last-child {
  margin-bottom: 0;
}
.text-bubble :deep(h1), .text-bubble :deep(h2), .text-bubble :deep(h3) {
  margin: 20px 0 12px 0;
  color: #2c3e50;
  font-weight: 600;
}
.text-bubble :deep(h3) {
  font-size: 18px;
  color: #409eff;
  border-left: 4px solid #409eff;
  padding-left: 12px;
  background: #f0f7ff;
  padding-top: 8px;
  padding-bottom: 8px;
  border-radius: 0 4px 4px 0;
}
.text-bubble :deep(p:last-child) {
  margin-bottom: 0;
}
.text-bubble :deep(code) {
  background: #f1f3f4;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 0.9em;
  color: #e83e8c;
}
.user-row .text-bubble :deep(code) {
  background: rgba(255,255,255,0.2);
  color: #fff;
}
.text-bubble :deep(ul) {
  padding-left: 18px;
  margin: 8px 0;
  list-style-type: none;
}
.text-bubble :deep(li) {
  position: relative;
  margin-bottom: 6px;
}
.text-bubble :deep(li::before) {
  content: '•';
  color: #409eff;
  font-weight: bold;
  position: absolute;
  left: -15px;
}
/* 将链接美化为类似按钮的样式 */
.text-bubble :deep(a) {
  color: #409eff;
  text-decoration: none;
  border-bottom: 1px dashed #409eff;
  transition: all 0.2s;
}
.text-bubble :deep(a:hover) {
  background: #ecf5ff;
  border-bottom-style: solid;
}
/* 针对水平分割线的优化 */
.text-bubble :deep(hr) {
  border: 0;
  border-top: 1px solid #ebeef5;
  margin: 15px 0;
}
.user-row .text-bubble {
  background: #409eff;
  color: #fff;
}
.thinking .dot {
  animation: wave 1.5s infinite ease-in-out;
}
.thinking .dot:nth-child(1) { animation-delay: 0s; }
.thinking .dot:nth-child(2) { animation-delay: 0.2s; }
.thinking .dot:nth-child(3) { animation-delay: 0.4s; }

@keyframes wave {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}

.input-area {
  padding: 30px 60px;
  background: linear-gradient(135deg, #fff 0%, #fafbfc 100%);
  border-top: 1px solid #f0f0f0;
  box-shadow: 0 -4px 12px rgba(0,0,0,0.05);
}
.input-tip {
  margin-top: 12px;
  font-size: 13px;
  color: #909399;
  text-align: left;
  opacity: 0.8;
}

/* 优化输入框样式 */
:deep(.el-textarea__inner) {
  border-radius: 8px 0 0 8px;
  border: 1px solid #dcdfe6;
  font-size: 15px;
  line-height: 1.5;
  padding: 12px 16px;
  transition: all 0.3s ease;
}
:deep(.el-textarea__inner:focus) {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}
:deep(.el-textarea__inner:hover) {
  border-color: #c0c4cc;
}

/* 优化按钮样式 */
:deep(.el-input-group__append) {
  border-radius: 0 8px 8px 0;
  border: 1px solid #dcdfe6;
  border-left: none;
  background: transparent;
  padding: 0;
}
:deep(.el-button--primary) {
  border-radius: 0 8px 8px 0;
  font-weight: 500;
  letter-spacing: 0.5px;
}
/* 响应式调整：如果是小屏幕PC，稍微收缩 */
@media screen and (max-height: 800px) {
  .chat-window {
    height: 95vh;
  }
}

/* PC端大屏幕优化 */
@media screen and (min-width: 1920px) {
  .chat-sidebar {
    width: 320px;
  }
  .messages-container {
    padding: 50px 80px;
    max-width: 1400px;
  }
  .chat-header {
    padding: 25px 80px;
  }
  .input-area {
    padding: 35px 80px;
  }
  .text-bubble {
    font-size: 16px;
    padding: 18px 26px;
  }
}

@media screen and (min-width: 2560px) {
  .chat-sidebar {
    width: 360px;
  }
  .sidebar-logo {
    padding: 0 30px 50px;
  }
  .logo-text {
    font-size: 22px;
  }
  .menu-item {
    padding: 16px 22px;
    font-size: 16px;
  }
}

/* 高DPI屏幕优化 */
@media screen and (-webkit-min-device-pixel-ratio: 2), 
       screen and (min-resolution: 192dpi) {
  .text-bubble {
    font-weight: 400;
  }
  .chat-header h3 {
    font-weight: 500;
  }
}
</style>
