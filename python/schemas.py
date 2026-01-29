from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ContactSubmissionBase(BaseModel):
    user_name: str
    project_name: Optional[str] = None
    project_description: str
    handle_status: str = '0'
    user_id: str
    phonenumber: str
    company: str
    entry_type: str
    contact_phone: Optional[str] = None
    mdse_id: Optional[int] = None

class ContactSubmissionCreate(ContactSubmissionBase):
    pass

class ContactSubmissionUpdateStatus(BaseModel):
    id: int
    handle_status: str

class ContactSubmissionResponse(ContactSubmissionBase):
    id: int
    submitted_time: datetime
    processed_time: Optional[datetime] = None

    class Config:
        from_attributes = True

class ChatMessage(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    message: str
    history: list[ChatMessage] = []
