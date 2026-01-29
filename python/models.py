from sqlalchemy import Column, Integer, String, DateTime, Text, BigInteger
from sqlalchemy.sql import func
from database import Base

class ContactSubmission(Base):
    __tablename__ = "contact_submissions"

    id = Column(Integer, primary_key=True, index=True)
    user_name = Column(String(100), nullable=False, comment='联系名')
    project_name = Column(String(200), nullable=True, comment='项目名')
    project_description = Column(String(500), nullable=False, comment='描述')
    submitted_time = Column(DateTime(timezone=True), server_default=func.now(), nullable=False, comment='提交时间')
    processed_time = Column(DateTime(timezone=True), nullable=True, comment='处理时间')
    handle_status = Column(String(50), nullable=False, default='0', comment='处理状态: 0=待处理, 1=已联系, 2=已报价, 3=已签约, 4=已忽略')
    user_id = Column(String(64), nullable=False, comment='用户id')
    phonenumber = Column(String(50), nullable=False, comment='手机号')
    company = Column(String(50), nullable=False, comment='公司名')
    update_user_id = Column(String(255), nullable=True, comment='修改人id')
    uuid = Column(String(255), nullable=True, comment='uuid')
    mdse_id = Column(BigInteger, nullable=True, comment='商品ID')
    entry_type = Column(String(50), nullable=False, comment='入口类型')
    contact_phone = Column(String(50), nullable=True, comment='联系电话-表单提交')
