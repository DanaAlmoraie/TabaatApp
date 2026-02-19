# ================================
# main.py — Taabat API
# ================================

from datetime import datetime, timedelta
from fastapi import FastAPI, Depends, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from jose import jwt, JWTError
from passlib.context import CryptContext
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv
from typing import List
import os

import models
from database import Base, engine, get_db

load_dotenv()

# =====================================
# Database Initialization
# =====================================
# مهم: تأكدي الجداول تنشأ على Supabase
# --------------------Base.metadata.create_all(bind=engine)

# =====================================
# Authentication Setup
# =====================================
pwd_context = CryptContext(schemes=["sha256_crypt"], deprecated="auto")

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")

if not SECRET_KEY:
    raise ValueError("SECRET_KEY is missing in .env")


# =====================================
# Helper Functions
# =====================================
def verify_password(plain_password, hashed):
    return pwd_context.verify(plain_password, hashed)


def get_password_hash(password):
    return pwd_context.hash(password)


def create_access_token(data: dict):
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    data.update({"exp": expire})
    return jwt.encode(data, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")

        if user_id is None:
            raise HTTPException(401, "Invalid token")

        user = db.query(models.User).filter(models.User.user_id == int(user_id)).first()

        if not user:
            raise HTTPException(401, "User not found")

        return user

    except JWTError:
        raise HTTPException(401, "Invalid token")


# =====================================
# Pydantic Schemas
# =====================================
class UserBase(BaseModel):
    name: str
    email: EmailStr
    password: str
    location: str | None = None
    latitude: float | None = None
    longitude: float | None = None
    role: str


class UserOut(BaseModel):
    user_id: int
    name: str
    email: EmailStr
    location: str | None
    latitude: float | None
    longitude: float | None
    role: str
    created_at: datetime | None

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class FarmCreate(BaseModel):
    name: str
    location: str
    fruits: List[str]
    is_open: bool = False


class ReminderCreate(BaseModel):
    message: str
    image_id: int | None = None
    farm_id: int | None = None


# =====================================
# FastAPI App
# =====================================
app = FastAPI(title="Taabat API")

origins = [
    "http://localhost",
    "http://127.0.0.1:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins= origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {"message": "Taabat API is running 🚜🍎"}


# ------------------------
# Register
# ------------------------
@app.post("/register", response_model=UserOut)
def register_user(user: UserBase, db: Session = Depends(get_db)):
    exists = db.query(models.User).filter(models.User.email == user.email).first()
    if exists:
        raise HTTPException(400, "Email already exists")

    hashed_pw = get_password_hash(user.password)

    db_user = models.User(
        name=user.name,
        email=user.email,
        password=hashed_pw,
        location=user.location,
        latitude=user.latitude,
        longitude=user.longitude,
        role=user.role,
        created_at=datetime.utcnow(),
    )

    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return db_user


# ------------------------
# Login
# ------------------------
@app.post("/login", response_model=Token)
def login(form: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
<<<<<<< HEAD

    user = db.query(models.User).filter(models.User.email == (form.username).lower()).first()
=======
    user = db.query(models.User).filter(models.User.email == form.username).first()
>>>>>>> 6807c90404d57c6e8f4e3f64d15ebc6ad802fa12

    if not user or not verify_password(form.password, user.password):
        raise HTTPException(401, "Invalid email or password")

    token = create_access_token({"sub": str(user.user_id)})
    return {"access_token": token, "token_type": "bearer"}


# ------------------------
# My Profile
# ------------------------
@app.get("/me", response_model=UserOut)
def get_me(current=Depends(get_current_user)):
    return current


# ------------------------
# Add Farm
# ------------------------
@app.post("/farms")
def add_farm(data: FarmCreate, current=Depends(get_current_user), db: Session = Depends(get_db)):
    if current.role != "Farmer":
        raise HTTPException(403, "Only farmers can add farms")

    farm = models.Farm(
        name=data.name,
        location=data.location,
        user_id=current.user_id,
        is_open=data.is_open
    )

    db.add(farm)
    db.commit()
    db.refresh(farm)

    return {"message": "Farm added", "farm": farm}


# ------------------------
# Get all open farms (shopper)
# ------------------------
@app.get("/farms")
def get_all_farms(db: Session = Depends(get_db)):

    farms = db.query(models.Farm).filter(models.Farm.is_open == True).all()
    return farms

# ------------------------
# Get My Farms (Farmer dashboard)
# ------------------------
@app.get("/farms/me")
def get_my_farms(current=Depends(get_current_user), db: Session = Depends(get_db)):
    return db.query(models.Farm).filter(models.Farm.user_id == current.user_id).all()


# ------------------------
# Upload Image (placeholder)
# ------------------------
@app.post("/fruit-images")
def upload_fruit_image(file: UploadFile = File(...), current=Depends(get_current_user)):
    return {"message": "Image uploaded", "filename": file.filename, "user": current.user_id}


# ------------------------
# Add Reminder
# ------------------------
@app.post("/reminders")
def add_reminder(data: ReminderCreate, current=Depends(get_current_user), db: Session = Depends(get_db)):
    reminder = models.Reminder(
        user_id=current.user_id,
        message=data.message,
        image_id=data.image_id,
        farm_id=data.farm_id,
        date_sent=datetime.utcnow(),
        is_read=False,
    )

    db.add(reminder)
    db.commit()
    db.refresh(reminder)

    return {"message": "Reminder added", "reminder": reminder}
