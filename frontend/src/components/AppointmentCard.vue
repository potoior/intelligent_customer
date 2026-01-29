<template>
  <el-card class="appointment-card" shadow="hover">
    <template #header>
      <div class="card-header">
        <span>预约确认</span>
        <el-tag type="success">意向咨询</el-tag>
      </div>
    </template>
    
    <div class="product-info">
      <h4>{{ productData.productName }}</h4>
      <p class="product-id">ID: {{ productData.productId }}</p>
    </div>

    <el-form :model="form" label-width="80px" class="appointment-form">
      <el-form-item label="姓名">
        <el-input v-model="form.userName" disabled placeholder="默认用户" />
      </el-form-item>
      <el-form-item label="电话">
        <el-input v-model="form.phonenumber" placeholder="请输入联系电话" />
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="form.description" type="textarea" placeholder="填写您的具体需求..." />
      </el-form-item>
    </el-form>

    <div class="card-footer">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" :loading="submitting" @click="onSubmit">确认提交</el-button>
    </div>
  </el-card>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'

const props = defineProps({
  productData: {
    type: Object,
    required: true,
    default: () => ({ productName: '未知商品', productId: '' })
  },
  // 可以在这里传入当前用户信息，或者组件内部去获取
  currentUser: {
    type: Object,
    default: () => ({ userName: '当前用户', phonenumber: '13800138000' })
  }
})

const emit = defineEmits(['submitted', 'cancelled'])

const submitting = ref(false)
const form = reactive({
  userName: props.currentUser.userName,
  phonenumber: props.currentUser.phonenumber,
  description: ''
})

const onSubmit = async () => {
  submitting.value = true
  try {
    const payload = {
       mdseId: props.productData.productId,
       projectName: props.productData.productName,
       projectDescription: form.description,
       phonenumber: form.phonenumber
       // userId 后端会处理
    }
    
    const response = await fetch('http://120.76.218.38:9533/api/contact/submit', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer ...' 
      },
      body: JSON.stringify(payload)
    })
    
    const result = await response.json()
    if (result.success) {
      ElMessage.success('预约提交成功！')
      emit('submitted') // 通知父组件隐藏卡片或显示成功状态
    } else {
      ElMessage.error('提交失败: ' + result.message)
    }
  } catch (e) {
    ElMessage.error('网络错误')
    console.error(e)
  } finally {
    submitting.value = false
  }
}

const onCancel = () => {
  emit('cancelled')
}
</script>

<style scoped>
.appointment-card {
  max-width: 400px;
  margin: 10px 0;
  border-radius: 8px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.product-info {
  background: #f5f7fa;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 15px;
}
.product-info h4 {
  margin: 0 0 5px 0;
  color: #303133;
}
.product-id {
  margin: 0;
  font-size: 12px;
  color: #909399;
}
.card-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 10px;
}
</style>
