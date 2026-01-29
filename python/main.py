import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os
import sys

# Add current directory to path so we can import modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from routers import contact, chat

load_dotenv()

app = FastAPI(title="Smart City Chat Backend", version="1.0.0")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(contact.router)
app.include_router(chat.router)

@app.get("/")
async def root():
    return {"message": "Smart City Chat Backend (Python) is running"}

if __name__ == "__main__":
    port = int(os.getenv("PORT", 9533))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)
