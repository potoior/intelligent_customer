/*
 Navicat Premium Data Transfer

 Source Server         : 47.107.191.16_3306
 Source Server Type    : MySQL
 Source Server Version : 50742 (5.7.42)
 Source Host           : 47.107.191.16:3306
 Source Schema         : cloud_smart_city

 Target Server Type    : MySQL
 Target Server Version : 50742 (5.7.42)
 File Encoding         : 65001

 Date: 23/01/2026 10:47:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for contact_submissions
-- ----------------------------
DROP TABLE IF EXISTS `contact_submissions`;
CREATE TABLE `contact_submissions`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系名',
  `project_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目名',
  `project_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述',
  `submitted_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `processed_time` datetime NOT NULL COMMENT '处理时间',
  `handle_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '处理状态: 0=待处理, 1=已联系, 2=已报价, 3=已签约, 4=已忽略',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户id',
  `phonenumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公司名',
  `update_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '修改人id',
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'uuid',
  `mdse_id` bigint(20) NULL DEFAULT NULL COMMENT '商品ID',
  `entry_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '入口类型: ECOSYSTEM_PARTNERSHIP=生态合作, ENABLEMENT_CONSULTING=赋能咨询',
  `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话-表单提交',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '联系我们提交记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contact_submissions
-- ----------------------------
INSERT INTO `contact_submissions` VALUES (1, '李文钦', '11111', '1111', '2026-01-05 10:25:27', '2026-01-12 09:54:02', 'CONTACT', 'bced8c47c9f64540919e7cb97d59c98e', '17316858106', '11111', '09ce951a-508c-46cf-b702-72fa9fd92df9', '68aab3625d3949fbbf226b24583da524', NULL, 'ECOSYSTEM_PARTNERSHIP', '17316858106');
INSERT INTO `contact_submissions` VALUES (2, 'chen', '智能项目', '智能项目智能项目智能项目智能项目', '2026-01-05 10:51:44', '2026-01-12 09:49:58', 'SIGN', '125f46a597c74bbbbb3faf38f8e34722', '13813331333', '完整性评估', '09ce951a-508c-46cf-b702-72fa9fd92df9', '68aab3625d3949fbbf226b24583da513', NULL, 'ENABLEMENT_CONSULTING', '13813331333');
INSERT INTO `contact_submissions` VALUES (3, 'cs', NULL, '测试测试测试测试测试测试测试测试测试测试测试测试测试', '2026-01-07 14:56:16', '2026-01-12 09:49:55', 'CONTACT', '4419401f4476499e98a4f184c9c93249', '13513513513', '测试', '09ce951a-508c-46cf-b702-72fa9fd92df9', '9f867a1c72e94297a7f406a35d13449a', NULL, 'ECOSYSTEM_PARTNERSHIP', '13513513511');
INSERT INTO `contact_submissions` VALUES (4, 'cs', '智能快递物流追踪平台', '嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息嘻嘻嘻休息休息', '2026-01-07 14:56:40', '2026-01-12 09:47:30', 'SIGN', '4419401f4476499e98a4f184c9c93249', '13513513513', '嘻嘻嘻休息休息', '09ce951a-508c-46cf-b702-72fa9fd92df9', 'f307176a31c54cf2a4ba15d696fe4281', 1202511287145, 'ENABLEMENT_CONSULTING', '13513513513');
INSERT INTO `contact_submissions` VALUES (5, '13513513513', NULL, '测试测试测试测试测试测试测试测试测试', '2026-01-07 15:54:06', '2026-01-07 15:54:06', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', '测试', NULL, '52bf34d89aea4c98a966a0f7f7f19ac5', NULL, 'ECOSYSTEM_PARTNERSHIP', '13513513511');
INSERT INTO `contact_submissions` VALUES (6, '13513513513', '智链门店与物流中枢系统', '135135135131351351351313513513513135135135131351351351313513513513135135135131351351351313513513513', '2026-01-08 14:35:27', '2026-01-08 14:35:27', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', 'cs', NULL, 'ec5e50f4713c4bb4a2fc9b5089653abd', 1202222255646, 'ENABLEMENT_CONSULTING', '13513513513');
INSERT INTO `contact_submissions` VALUES (7, '测试', '智链门店与物流中枢系统', '1351351351313513513513135135135131351351351313513513513135135135131351351351313513513513135135135131351351351313513513513135135135131351351351313513513513', '2026-01-08 14:41:54', '2026-01-19 09:54:52', 'SIGN', '8b218c02c85143b88e5c414c15efbca8', '13513513513', '测试', '78bbd55c-c838-426b-90bd-65f95ea4eee0', 'b0c74b267b674449bf033831b1789b60', 1202222255646, 'ENABLEMENT_CONSULTING', '13513513513');
INSERT INTO `contact_submissions` VALUES (8, '测试', '智链门店与物流中枢系统', '13513513513135135135131351351351313513513513135135135131351351351313513513513135135135131351351351313513513513', '2026-01-08 16:41:26', '2026-01-08 16:41:26', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', 'xxx', NULL, '2a2222c954524f6f9b47b6c2a8ed2e09', 1202222255646, 'ENABLEMENT_CONSULTING', '13513513513');
INSERT INTO `contact_submissions` VALUES (9, '测试', '智链门店与物流中枢系统', '1351351351313513513513135135135131351351351313513513513135135135131351351351313513513513', '2026-01-08 17:02:21', '2026-01-08 17:02:21', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', 'xxx', NULL, '8ad3cfd213c644f5bc2cfb27541f09fa', 1202222255646, 'ENABLEMENT_CONSULTING', '13513513513');
INSERT INTO `contact_submissions` VALUES (10, '测试', NULL, '测试19测试19测试19测试19测试19测试19测试19测试19测试19测试19', '2026-01-09 14:43:07', '2026-01-09 14:43:07', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', '测试19', NULL, 'cda2770eea1d4707a1cd87fafaefeed4', NULL, 'ECOSYSTEM_PARTNERSHIP', '13513513519');
INSERT INTO `contact_submissions` VALUES (11, '测试', '智链门店与物流中枢系统', '测试19测试19测试19测试19测试19测试19测试19测试19测试19测试19测试19', '2026-01-09 14:43:22', '2026-01-09 14:43:22', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', '测试19', NULL, '02ef834cec154a60a9bc4d0925931c75', 1202222255646, 'ENABLEMENT_CONSULTING', '13513513519');
INSERT INTO `contact_submissions` VALUES (12, '测试', NULL, '测试19测试19测试19测试19测试19测试19测试19测试19测试19测试19', '2026-01-09 14:44:20', '2026-01-09 14:44:20', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', '生态合作', NULL, '0388faa77b8340118477ff557e989759', NULL, 'ECOSYSTEM_PARTNERSHIP', '13513531531');
INSERT INTO `contact_submissions` VALUES (13, '测试', '智链门店与物流中枢系统', '赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询赋能咨询', '2026-01-09 14:44:50', '2026-01-09 14:44:50', 'WAIT_HANDLE', '8b218c02c85143b88e5c414c15efbca8', '13513513513', '赋能咨询', NULL, '245ce1c335384433ba129ab97b678c4a', 1202222255646, 'ENABLEMENT_CONSULTING', '13513513513');
INSERT INTO `contact_submissions` VALUES (14, 'chen', '数字化拍卖商品运营系统', '11', '2026-01-19 09:24:22', '2026-01-22 09:24:22', 'WAIT_HANDLE', '125f46a597c74bbbbb3faf38f8e34722', '13813331333', '111', NULL, '54b2797abfea4bfe841cdcbb8c93eeb9', 1202222255647, 'ENABLEMENT_CONSULTING', '13313331333');

-- ----------------------------
-- Table structure for cus_user
-- ----------------------------
DROP TABLE IF EXISTS `cus_user`;
CREATE TABLE `cus_user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID（对外业务ID）',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名称',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `created_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cus_user
-- ----------------------------
INSERT INTO `cus_user` VALUES (4, '125f46a597c74bbbbb3faf38f8e34722', 'chen', '13813331333', '$2a$10$b5M2CkD4y2W6ZNxYMntmruYmBrCWwkrBVi4VRzao8oqsxjJxWfRF6', '2025-12-24 11:12:43');
INSERT INTO `cus_user` VALUES (7, '01103d05cc774f088e4e0721ad505a75', 'chen123', '15888888888', '$2a$10$0ahCU747IZk7YPubzGnY3OdFJhK6VUwNuYk97rwSahkggwSf03lEe', '2025-12-26 15:46:49');
INSERT INTO `cus_user` VALUES (8, '2abf362121ba4fbfba15cfff4fefb75e', 'chen', '15818881888', '$2a$10$k1k9IN4z2WPVtwso8bvm/.71cn5nhwzm3eOSnOq.LdXzKYsB0GP2.', '2025-12-25 18:18:37');
INSERT INTO `cus_user` VALUES (9, 'c2860f3703cb4d75a98ff96a8b99c4f6', 'chen1234', '13313441344', '$2a$10$oyomefT/2fTWRFiCRV4YB.8Nps/botl.P3WuWnVCBnnbjHSokd6MC', '2025-12-26 15:51:49');
INSERT INTO `cus_user` VALUES (10, '035b9eac8e6944b58eeee1432e36f088', 'admin123', '13555665566', '$2a$10$KCkWGf034WeuLSdvhDZQ/OFbK72diqDxiABjJ0Oai.G5sOJ3oYd5m', '2025-12-30 11:01:33');
INSERT INTO `cus_user` VALUES (11, 'a4fee5f0faed406b8f1a43b36b0efbf2', 'admionhi1', '13333443388', '$2a$10$VYIok7brQCfJ.H2i8/trGO8xGR8Vu4IkzKocbU6tvuZuDczyT73DW', '2025-12-30 11:12:45');
INSERT INTO `cus_user` VALUES (12, 'c17d6623c4f64164b03c23d7c7eec74a', 'adafaw', '18013331333', '$2a$10$UnQtoIXLajhDMFCtkRV./.ubiznZ4hYQlb6ZBWz.Us3HG7dCGs3tW', '2025-12-30 11:13:10');
INSERT INTO `cus_user` VALUES (13, '2bb909399c9a4963b59c80a961d45768', 'chen 12', '13441344365', '$2a$10$z0I66UWKbW6e8lTXW/QSCufMirPYa5ZF5NRv5M7UpgzAJmKMmMPAy', '2025-12-30 15:50:54');
INSERT INTO `cus_user` VALUES (15, '8b218c02c85143b88e5c414c15efbca8', '测试', '13513513513', '$2a$10$Etba/SBaax4qWdWNDTfZTeiNj5Q3sAUJibadi1m4ptVne7lUUm6sW', '2026-01-08 14:40:39');
INSERT INTO `cus_user` VALUES (16, '5a24c18f4ec74bbc9b9181f2657ef1d0', 'admin', '17316858106', '$2a$10$6qcASjYuj4W.KsqlqzVW/efK9HQWYM8Ln8zuO65gk3khF3X/ow.2S', '2026-01-19 10:40:48');

-- ----------------------------
-- Table structure for enabling_mdse_photo
-- ----------------------------
DROP TABLE IF EXISTS `enabling_mdse_photo`;
CREATE TABLE `enabling_mdse_photo`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `enabling_mdse_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `enabling_mdse_photo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of enabling_mdse_photo
-- ----------------------------
INSERT INTO `enabling_mdse_photo` VALUES (1, '1202511287145', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (2, '1202511287145', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (3, '1202511287145', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (4, '1202511287145', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (8, '1202222255647', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (9, '1202222255647', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (10, '1202511287148', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (11, '1202511287148', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (12, '1202511287150', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (13, '1202511287150', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (14, '1202511287154', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (15, '1202511287154', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (16, '1202511287157', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (17, '1202511287157', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (18, '1202222255788', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (19, '1202222255788', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (20, '2222511287148', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (21, '2222511287148', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (22, '3204442255788', 'http://localhost:9217/enablingPhoto/007.png');
INSERT INTO `enabling_mdse_photo` VALUES (23, '3204442255788', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (24, '1767865114144', 'http://127.0.0.1:8999/upload/enablingPhoto/930f8a03-e3b3-40ee-9c66-921700702411.jpeg');
INSERT INTO `enabling_mdse_photo` VALUES (26, 'fb43e453-72ae-4081-9ebc-5b0b2ed2b112', 'http://127.0.0.1:8999/upload/enablingPhoto/8c88ecea-4c02-4019-a201-95a153551ce3.jpeg');
INSERT INTO `enabling_mdse_photo` VALUES (29, '33ef75eb-367e-4a27-95e4-e214af671906', 'http://127.0.0.1:8999/upload/enablingPhoto/8c88ecea-4c02-4019-a201-95a153551ce3.jpeg');
INSERT INTO `enabling_mdse_photo` VALUES (30, 'dbdcb03c-6d52-4138-a640-8607ae46fa62', 'http://127.0.0.1:8999/upload/enablingPhoto/8ef99464-c03f-4e42-b450-2c172bd77d31.jpeg');
INSERT INTO `enabling_mdse_photo` VALUES (31, 'd0ca58b8-8450-48b0-a8f7-8539c9d85451', 'http://127.0.0.1:8999/upload/enablingPhoto/69195ca7-99ec-4be3-936b-be3ee7247cb1.jpeg');
INSERT INTO `enabling_mdse_photo` VALUES (32, '1202222255646', 'http://localhost:9217/enablingPhoto/008.png');
INSERT INTO `enabling_mdse_photo` VALUES (33, '1202222255646', 'http://localhost:9217/enablingPhoto/009.png');
INSERT INTO `enabling_mdse_photo` VALUES (34, '1202222255646', 'http://localhost:9217/enablingPhoto/007.png');

-- ----------------------------
-- Table structure for enabling_platform
-- ----------------------------
DROP TABLE IF EXISTS `enabling_platform`;
CREATE TABLE `enabling_platform`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mdse_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `mdse_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `mdse_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品类型',
  `mdse_tag_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品标签类型',
  `industry_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属行业类型',
  `mdse_pecificLogo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品甲方logo',
  `mdse_price` double NOT NULL COMMENT '商品价格',
  `mdse_intro` varchar(3000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品描述',
  `first_party` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '甲方公司名称',
  `second_party` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '乙方公司名称',
  `add_time` datetime NOT NULL COMMENT '插入时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `downaway_time` datetime NULL DEFAULT NULL COMMENT '下架时间',
  `mdse_link` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品链接',
  `mdse_account` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品账号',
  `mdse_password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品密码',
  `add_op_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '添加人',
  `downaway_op_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '下架操作人',
  `mdse_status` bit(1) NOT NULL COMMENT '0-上架 1-下架',
  `putaway_op_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上架操作人',
  `putaway_time` datetime NULL DEFAULT NULL COMMENT '上架时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of enabling_platform
-- ----------------------------
INSERT INTO `enabling_platform` VALUES (1, '1202511287145', '智能快递物流追踪平台', 'RESEARCH_DEVELOPMENT', 'DATA_ACQUISITION', 'IA', 'http://localhost:9217/enablingPhoto/001.png', 5000012, '边缘数据实时分析平台是一款面向城市轨道交通运营管理全流程和复杂客流场景设计的数据智能管理平台，旨在提供全面的运营数据整合、实时可视化呈现、科学客流预测及异常风险预警能力。结合了大数据分析技术方案和城市轨道交通运营实践，是针对轨道交通数据管理与运营决策领域设计的一体化智能平台，集全环节数据采集、多维度可视化展示、精准客流预测和跨主体协同于一体，保障轨道交通运营数据的实时、准确、可复用，助力城市轨道交通运营效率提升与管理精细化升级。', '广东金上网络科技有限公司', '广东行知天下网络科技有限公司', '2025-11-28 10:25:42', '2025-12-23 18:04:15', NULL, 'localhost:9084', 'admin', '123456789999', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:08');
INSERT INTO `enabling_platform` VALUES (2, '1202222255646', '智链门店与物流中枢系统', 'MANUFACTURING', 'SYSTEM_INFORMATION', 'PCB', 'http://localhost:9217/enablingPhoto/002.png', 1004862, '电子合同管理智能化软件是一款面向各行业企业财务数字化管理场景设计的财务管理平台，旨在提供全面的财务核算、业财协同、数据可视化及个性化定制能力。结合了开源技术方案和企业财务实践，是针对企业财务管理与数字化转型领域设计的一体化财务系统，集多账套管理、智能凭证处理、业财数据整合、报表自动生成和多角色权限管控于一体，保障企业财务数据的准确、安全、高效流转，助力企业财务数字化升级与管理效率提升', '韶关市宅甲网络科技有限公司', '云润大数据服务有限公司', '2025-11-28 10:35:42', '2026-01-19 10:41:55', NULL, 'localhost:9085/springboot6alf1/front/index.html', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-12 17:53:51');
INSERT INTO `enabling_platform` VALUES (3, '1202222255647', '数字化拍卖商品运营系统', 'OPERATIONS_MANAGEMENT', 'ELEMENTAL_GUARANTEE', 'MFP', 'http://localhost:9217/enablingPhoto/006.png', 254100, '计算机系统安全巡检平台是一款基于 Django 框架开发的网络安全事件应急响应与处置系统，旨在为中小型网络环境提供全面的安全监控、事件处置及数据保护解决方案。系统融合后端 Django、前端 layui 框架与 MySQL 数据库技术，实现了从网络攻击监测到应急响应、数据恢复的全流程管理，同时具备系统资源监控与可视化展示能力，是一款兼具实用性与学习价值的安全工具', '韶关市宅甲网络科技有限公司', '云润大数据服务有限公司', '2025-11-28 10:35:42', '2025-11-28 10:35:46', NULL, 'localhost:9086', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:10');
INSERT INTO `enabling_platform` VALUES (4, '1202511287148', '全域AI识别无人机调度系统', 'STORAGE_LOGISTICS', 'PRODUCT_QUALITY', 'SPG', 'http://localhost:9217/enablingPhoto/004.png', 180002, '客户关系智能管理系统是一款面向有客户资源管理需求的企业销售团队、需规范销售流程的中小企业销售部门、追求销售业绩提升与数据化管理的销售管理者，以及需要打通 “线索 - 客户 - 商机 - 合同 - 回款” 全链路的销售相关岗位人员的专业化企业销售全生命周期管理与客户资源高效运营平台。核心聚焦 “企业客户资源精准管控与高效协同” 与 “销售全流程数据化运营与业绩提升” 两大核心需求，旨在通过 Spring Boot3+Vue3 前后端分离的分层技术架构，结合 Spring Security OAuth2 与 JWT 认证机制、MyBatisPlus 数据库优化、Redis 缓存加速等技术，解决传统销售管理模式中 “客户资源分散难整合、销售流程混乱无规范、客户跟进记录不完整” 的痛点', '广东金上网络科技有限公司', '广东行知天下网络科技有限公司', '2025-11-28 10:25:42', '2025-11-28 10:25:47', NULL, 'localhost:9087', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:14');
INSERT INTO `enabling_platform` VALUES (5, '1202511287150', '匠芯养修数字化车间系统', 'INFORMATION_SAFETY', 'PRODUCT_DESIGN', 'BS', 'http://localhost:9217/enablingPhoto/005.png', 422453, '区块链溯源商品管理系统是一款面向农产品全产业链和复杂流通场景设计的溯源管理平台，旨在提供全面的信息记录、可信存证、全程追溯及防伪验证能力。结合了区块链技术方案和农业行业实践，是针对农产品安全与流通领域设计的一体化溯源管理平台，集全流程信息采集、区块链存证、扫码溯源和多角色协同于一体，保障农产品溯源信息的真实、透明、可追溯，助力农产品安全管控与产业升级', '广东金上网络科技有限公司', '广东行知天下网络科技有限公司', '2025-11-28 10:25:42', '2025-11-28 10:25:47', NULL, 'localhost:9088', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:16');
INSERT INTO `enabling_platform` VALUES (6, '1202511287154', '枢机智慧医疗资源管理系统', 'DATA_COMMODITY', 'TECHNOLOGICAL_DESIGN', 'AI', 'http://localhost:9217/enablingPhoto/001.png', 103855, '视频数据结构化智能传输平台是一款面向泛娱乐内容传播与互动场景开发的轻量化视频平台解决方案，旨在打破传统视频传播的单一性，为用户提供 “创作 - 消费 - 互动” 一体化的视频服务体验，同时为平台运营者搭建高效、合规的内容管理体系。该系统深度结合视频行业用户需求与技术趋势，整合内容生产工具、多元消费场景、实时互动功能及智能合规管控能力，形成覆盖视频全生命周期的运营支撑平台，助力构建 “低门槛创作 + 高体验消费 + 强合规运营” 的轻量化视频生态', '广东金上网络科技有限公司', '广东行知天下网络科技有限公司', '2025-11-28 10:25:42', '2025-11-28 10:25:47', NULL, 'localhost:9089', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:18');
INSERT INTO `enabling_platform` VALUES (7, '1202511287157', '智能化养殖与生产管理平台', 'MDSE_RL', 'QUALITY_CONTROL', 'INDUSTRY_RL', 'http://localhost:9217/enablingPhoto/002.png', 30255, '收银机远程管理系统是一种基于云计算技术的软件服务平台，它通过互联网连接所有门店的POS收银机，使管理者能够从总部或任意地点集中监控、管理和分析各个门店的运营数据。该系统是现代连锁企业实现标准化、高效化和数据化运营的核心工具', '广东金上网络科技有限公司', '广东行知天下网络科技有限公司', '2025-11-28 10:25:42', '2026-01-15 11:55:48', NULL, 'localhost:9090', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 11:55:48');
INSERT INTO `enabling_platform` VALUES (8, '1202222255788', '畜牧业智能全链管理平台', 'STORAGE_LOGISTICS', 'DEVICE_MANAGEMENT', 'PCB', 'http://localhost:9217/enablingPhoto/003.png', 3005222, '智能快递物流追踪平台是一款面向快递物流全流程运转和多角色协同场景设计的数字化追踪管理平台，旨在提供全面的快递信息整合、实时物流状态追踪及跨参与方协同管理能力。结合了成熟的实时数据传输技术方案和快递物流行业实际运营管理实践，是针对快递物流服务与运营决策领域设计的一体化智能平台，集全周期快递数据采集、多维度物流查询、可视化轨迹展示和跨系统资源协同于一体，保障快递物流数据的准确、实时、可共享，助力快递物流行业服务响应效率提升与管理规范化升级', '韶关市宅甲网络科技有限公司', '云润大数据服务有限公司', '2025-11-28 10:35:42', '2025-11-28 10:35:46', NULL, 'localhost:9091', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:21');
INSERT INTO `enabling_platform` VALUES (9, '2222511287148', '扶贫助农智慧赋能系统', 'INFORMATION_SAFETY', 'ENERGY_MANAGEMENT', 'MFP', 'http://localhost:9217/enablingPhoto/004.png', 62000, '智能化招聘服务同步管理平台是一款基于 Java 技术栈开发的轻量化在线招聘求职协同平台，核心服务于 “求职者 - 招聘方 - 管理员” 三方角色，旨在打破传统招聘中的信息壁垒、流程低效等问题，通过标准化功能模块与实时资源协同，实现 “个人求职精准匹配、企业招聘高效落地、平台管理合规可控” 的一体化招聘求职解决方案', '广东金上网络科技有限公司', '广东行知天下网络科技有限公司', '2025-11-28 10:25:42', '2025-11-28 10:25:47', NULL, 'localhost:9092', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:23');
INSERT INTO `enabling_platform` VALUES (10, '3204442255788', '电网脉络智能运维与预警平台', 'MANUFACTURING', 'PURCHASING_MANAGEMENT', 'AI', 'http://localhost:9217/enablingPhoto/005.png', 8085, '自然语言处理文本分析系统是基于深度学习的中英双语文本情感分析系统，采用前后端分离架构。后端使用Flask+PyTorch实现，集成TextCNN、BiLSTM、BERT三种主流深度学习模型，支持模型训练、管理和推理。前端基于Vue3+TypeScript+ElementPlus构建现代化界面，提供直观的情感分析、模型管理和训练监控功能，支持ChnSentiCorp中文数据集和IMDb英文数据集的自动下载与预处理', '韶关市宅甲网络科技有限公司', '云润大数据服务有限公司', '2025-11-28 10:35:42', '2025-11-28 10:35:46', NULL, 'localhost:9093', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:25');
INSERT INTO `enabling_platform` VALUES (11, '3204442255789', '电网脉络智能运维与预警平台', 'MANUFACTURING', 'PURCHASING_MANAGEMENT', 'AI', 'http://localhost:9217/enablingPhoto/005.png', 8085, '自然语言处理文本分析系统是基于深度学习的中英双语文本情感分析系统，采用前后端分离架构。后端使用Flask+PyTorch实现，集成TextCNN、BiLSTM、BERT三种主流深度学习模型，支持模型训练、管理和推理。前端基于Vue3+TypeScript+ElementPlus构建现代化界面，提供直观的情感分析、模型管理和训练监控功能，支持ChnSentiCorp中文数据集和IMDb英文数据集的自动下载与预处理', '韶关市宅甲网络科技有限公司', '云润大数据服务有限公司', '2025-11-28 10:35:42', '2025-11-28 10:35:46', NULL, 'localhost:9084', 'admin', '123456', '09ce951a-508c-46cf-b702-72fa9fd92df9', NULL, b'0', '09ce951a-508c-46cf-b702-72fa9fd92df9', '2026-01-15 09:19:27');

