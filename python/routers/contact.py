from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update
from typing import List
import database
import models
import schemas
from datetime import datetime

router = APIRouter(prefix="/api/contact", tags=["contact"])

@router.post("/submit", response_model=schemas.ContactSubmissionResponse)
async def submit_contact(contact: schemas.ContactSubmissionCreate, db: AsyncSession = Depends(database.get_db)):
    db_contact = models.ContactSubmission(**contact.model_dump())
    db.add(db_contact)
    await db.commit()
    await db.refresh(db_contact)
    return db_contact

@router.get("/list", response_model=List[schemas.ContactSubmissionResponse])
async def list_contacts(db: AsyncSession = Depends(database.get_db)):
    result = await db.execute(select(models.ContactSubmission).order_by(models.ContactSubmission.submitted_time.desc()))
    return result.scalars().all()

@router.put("/update-status")
async def update_status(update_req: schemas.ContactSubmissionUpdateStatus, db: AsyncSession = Depends(database.get_db)):
    stmt = (
        update(models.ContactSubmission)
        .where(models.ContactSubmission.id == update_req.id)
        .values(handle_status=update_req.handle_status, processed_time=datetime.now())
    )
    await db.execute(stmt)
    await db.commit()
    return {"message": "Status updated successfully"}
