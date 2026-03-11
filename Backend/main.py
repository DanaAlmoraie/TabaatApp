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
import requests  # ✅ NEW: for calling external weather API

import models
from database import Base, engine, get_db

load_dotenv()

# =====================================
# Database Initialization
# =====================================
# --------------------Base.metadata.create_all(bind=engine)

# =====================================
# Authentication Setup
# =====================================
pwd_context = CryptContext(schemes=["sha256_crypt"], deprecated="auto")

SECRET_KEY = os.getenv("SECRET_KEY") or "TaabatVerySecureKey2025!"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")


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
    latitude: float | None
    longitude: float | None

class FarmOut(BaseModel):
    farm_id: int
    name: str
    location: str | None
    fruits: List[str] | None = []
    is_open: bool
    latitude: float | None
    longitude: float | None
    distance_km: float | None = None

    class Config:
        from_attributes = True

class FarmUpdate(BaseModel):
    name: str
    location: str
    fruits: List[str]
    is_open: bool
    latitude: float | None
    longitude: float | None

class ReminderCreate(BaseModel):
    message: str
    image_id: int | None = None
    farm_id: int | None = None


class NutritionOut(BaseModel):
    
    fruit_type: str
    energy: float | None = None
    water: float | None = None
    protein: float | None = None
    total_fat: float | None = None
    carbs: float | None = None
    fiber: float | None = None
    sugar: float | None = None
    calcium: float | None = None
    iron: float | None = None

    class Config:
        from_attributes = True


# ✅ NEW: Weather response schema
class WeatherOut(BaseModel):
    temperature_c: float
    humidity: float
    wind_kph: float
    rain_mm: float
    condition: str


# =====================================
# FastAPI App
# =====================================
app = FastAPI(title="Taabat API")

origins = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:5000",
    "http://localhost:8080",
    "http://127.0.0.1:5500",
    "http://127.0.0.1:8000",

]

app.add_middleware(
    CORSMiddleware,
    allow_origins= ["*"],
    allow_credentials=False,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["Authorization",
        "Content-Type",
        "Accept",
        "Origin",
        "User-Agent",
        "DNT",
        "Cache-Control",
        "X-Mx-ReqToken",
        "Keep-Alive",
        "X-Requested-With",
        "If-Modified-Since",
    ],
    expose_headers=["Authorization"],
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
        created_at=datetime.utcnow().date(),
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

    user = db.query(models.User).filter(models.User.email == (form.username).lower()).first()

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
# Update My Profile
# ------------------------
class UpdateUser(BaseModel):
    name: str
    email: EmailStr
    password: str | None = None
    
    

@app.put("/me", response_model=UserOut)
def update_me(
    data: UpdateUser,
    current=Depends(get_current_user),
    db: Session = Depends(get_db)
):

    current.name = data.name
    current.email = data.email

    email_exists = db.query(models.User)\
        .filter(models.User.email == data.email, models.User.user_id != current.user_id)\
        .first()

    if email_exists:
        raise HTTPException(400, "Email already used")

    if data.password and data.password.strip() != "":
        current.password = get_password_hash(data.password)


    db.commit()
    db.refresh(current)

    return current

# ------------------------
# Add Farm
# ------------------------
@app.post("/farms")
def add_farm(
    data: FarmCreate,
    current=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if current.role != "Farmer":
        raise HTTPException(403, "Only farmers can add farms")

    farm = models.Farm(
        name=data.name,
        location=data.location,
        user_id=current.user_id,
        is_open=data.is_open,
        latitude=data.latitude,
        longitude=data.longitude,
    )

    db.add(farm)
    db.commit()
    db.refresh(farm)
 
    if data.fruits:
        for fruit_name in data.fruits:
            fruit = db.query(models.Fruit).filter(models.Fruit.fruit_type == fruit_name).first()

            if not fruit:
                fruit = models.Fruit(fruit_type=fruit_name)
                db.add(fruit)
                db.commit()
                db.refresh(fruit)

            link = models.FarmFruit(
                farm_id=farm.farm_id,
                fruit_id=fruit.fruit_id
            )

            db.add(link)

        db.commit()
    print("DATA IS 8 RECIVED:",data)
    return {"message": "Farm added", "farm_id": farm.farm_id}



from math import radians, cos, sin, asin, sqrt

def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # KM
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat / 2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2)**2
    c = 2 * asin(sqrt(a))
    return R * c


# ------------------------
# Get all open farms (shopper) - AUTH REQUIRED + SORTED BY DISTANCE
# ------------------------
@app.get("/farms", response_model=List[FarmOut])
def get_all_farms(
    current=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    # لازم اليوزر يكون محدد لوكيشنه
    if current.latitude is None or current.longitude is None:
        raise HTTPException(400, "User location not set")

    farms = db.query(models.Farm).filter(models.Farm.is_open == True).all()

    result = []

    for farm in farms:

        # نطلع أسماء الفواكه
        fruits = []
        for f in farm.fruits:
            if f.fruit:
                fruits.append(f.fruit.fruit_type)

        distance = None

        # لو المزرعة ما عندها لوكيشن نخليها آخر شيء
        if farm.latitude is not None and farm.longitude is not None:
            distance = haversine(
                current.latitude,
                current.longitude,
                farm.latitude,
                farm.longitude
            )

        result.append({
            "farm_id": farm.farm_id,
            "name": farm.name,
            "location": farm.location,
            "fruits": fruits,
            "is_open": farm.is_open,
            "latitude": farm.latitude,
            "longitude": farm.longitude,
            "distance_km": round(distance, 2) if distance else None
        })

    # ترتيب: اللي عندها مسافة أول، واللي بدون لوكيشن آخر
    result.sort(key=lambda x: (x["distance_km"] is None, x["distance_km"] or 10**9))
    return result


# ------------------------
# Get My Farms
# ------------------------
@app.get("/farms/me")
def get_my_farms(current=Depends(get_current_user), db: Session = Depends(get_db)):

    farms = db.query(models.Farm).filter(models.Farm.user_id == current.user_id).all()

    result = []

    for farm in farms:
        fruits = [f.fruit.fruit_type for f in farm.fruits]

        result.append({
            "farm_id": farm.farm_id,
            "name": farm.name,
            "location": farm.location,
            "latitude": farm.latitude,
            "longitude": farm.longitude,
            "is_open": farm.is_open,
            "fruits": fruits
        })

    return result


# ------------------------
# Update Farm
# ------------------------
@app.put("/farms/{farm_id}")
def update_farm(
    farm_id: int,
    data: FarmUpdate,
    current=Depends(get_current_user),
    db: Session = Depends(get_db)
):

    farm = db.query(models.Farm).filter(models.Farm.farm_id == farm_id).first()

    if not farm:
        raise HTTPException(404, "Farm not found")

    if farm.user_id != current.user_id:
        raise HTTPException(403, "Not your farm")

    farm.name = data.name
    farm.location = data.location
    farm.is_open = data.is_open
    farm.latitude = data.latitude
    farm.longitude = data.longitude

    db.query(models.FarmFruit).filter(models.FarmFruit.farm_id == farm_id).delete()
    
    for fruit_name in data.fruits:

        fruit = db.query(models.Fruit).filter(models.Fruit.fruit_type == fruit_name).first()

        if not fruit:
            fruit = models.Fruit(fruit_type=fruit_name)
            db.add(fruit)
            db.commit()
            db.refresh(fruit)

        link = models.FarmFruit(
            farm_id=farm_id,
            fruit_id=fruit.fruit_id
        )
        db.add(link)

    db.commit()

    return {"message": "Farm updated successfully"}


# ------------------------
# Delete Farm
# ------------------------
@app.delete("/farms/{farm_id}")
def delete_farm(
    farm_id: int,
    current=Depends(get_current_user),
    db: Session = Depends(get_db)
):

    farm = db.query(models.Farm).filter(models.Farm.farm_id == farm_id).first()

    if not farm:
        raise HTTPException(404, "Farm not found")

    if farm.user_id != current.user_id:
        raise HTTPException(403, "Not your farm")

    db.delete(farm)
    db.commit()

    return {"message": "Farm deleted"}


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
def add_reminder(
    data: ReminderCreate,
    current=Depends(get_current_user),
    db: Session = Depends(get_db),
):
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


# ------------------------
# Update My Location (User)
# ------------------------
class UpdateLocation(BaseModel):
    latitude: float
    longitude: float


@app.patch("/users/me/location")
def update_my_location(
    data: UpdateLocation,
    current=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    current.latitude = data.latitude
    current.longitude = data.longitude

    db.commit()
    db.refresh(current)

    return {
        "message": "User location updated",
        "latitude": current.latitude,
        "longitude": current.longitude
    }


# ------------------------
# Update Farm Location (Farmer)
# ------------------------
@app.patch("/farms/{farm_id}/location")
def update_farm_location(
    farm_id: int,
    data: UpdateLocation,
    current=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    farm = db.query(models.Farm).filter(models.Farm.farm_id == farm_id).first()

    if not farm:
        raise HTTPException(404, "Farm not found")

    if farm.user_id != current.user_id:
        raise HTTPException(403, "Not your farm")

    farm.latitude = data.latitude
    farm.longitude = data.longitude

    db.commit()
    db.refresh(farm)

    return {
        "message": "Farm location updated",
        "farm_id": farm.farm_id,
        "latitude": farm.latitude,
        "longitude": farm.longitude
    }


# ------------------------
# Get Nearby Farms (Shopper)
# ------------------------
from math import radians, cos, sin, asin, sqrt

def haversine(lat1, lon1, lat2, lon2):
    """
    Calculate distance between two points in KM
    """
    R = 6371  # Earth radius in KM

    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)

    a = sin(dlat / 2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2)**2
    c = 2 * asin(sqrt(a))

    return R * c


@app.get("/farms/nearby")
def get_nearby_farms(
    radius_km: float = 10,
    current=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if current.latitude is None or current.longitude is None:
        raise HTTPException(400, "User location not set")

    farms = db.query(models.Farm).filter(
        models.Farm.latitude.isnot(None),
        models.Farm.longitude.isnot(None),
        models.Farm.is_open == True
    ).all()

    nearby = []

    for farm in farms:
        distance = haversine(
            current.latitude,
            current.longitude,
            farm.latitude,
            farm.longitude
        )

        if distance <= radius_km:
            nearby.append({
                "farm_id": farm.farm_id,
                "name": farm.name,
                "location": farm.location,
                "latitude": farm.latitude,
                "longitude": farm.longitude,
                "distance_km": round(distance, 2)
            })

    nearby.sort(key=lambda x: x["distance_km"])

    return {
        "user_location": {
            "latitude": current.latitude,
            "longitude": current.longitude
        },
        "radius_km": radius_km,
        "farms_found": len(nearby),
        "farms": nearby
    }


# ------------------------
# Get Nutrition by Fruit Type (for AI model output)
# ------------------------
@app.get("/nutrition/by-fruit/{fruit_type}", response_model=NutritionOut)
def get_nutrition_by_fruit(fruit_type: str, db: Session = Depends(get_db)):
    

    nutrition: models.NutritionalInfo | None = (
        db.query(models.NutritionalInfo)
        .join(models.FruitImage, models.NutritionalInfo.image_id == models.FruitImage.image_id)
        .join(models.Fruit, models.FruitImage.fruit_id == models.Fruit.fruit_id)
        .filter(models.Fruit.fruit_type == fruit_type)
        .first()
    )

    if not nutrition:
        raise HTTPException(404, "Nutrition data not found for this fruit")

    fruit_type_value = (
        nutrition.image.fruit.fruit_type
        if nutrition.image and nutrition.image.fruit
        else fruit_type
    )

    return NutritionOut(
        fruit_type=fruit_type_value,
        energy=nutrition.energy,
        water=nutrition.water,
        protein=nutrition.protein,
        total_fat=nutrition.total_fat,
        carbs=nutrition.carbs,
        fiber=nutrition.fiber,
        sugar=nutrition.sugar,
        calcium=nutrition.calcium,
        iron=nutrition.iron,
    )


# ------------------------
# ✅ Weather Endpoint
# ------------------------
@app.get("/weather", response_model=WeatherOut)
def get_weather(lat: float, lon: float):
    
    try:
        url = "https://api.open-meteo.com/v1/forecast"
        params = {
            "latitude": lat,
            "longitude": lon,
            "current": "temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m",
        }
        r = requests.get(url, params=params, timeout=5)
        r.raise_for_status()
        data = r.json()
        current = data.get("current", {})

        temp = float(current.get("temperature_2m"))
        humidity = float(current.get("relative_humidity_2m", 0.0))
        wind = float(current.get("wind_speed_10m", 0.0))
        rain = float(current.get("precipitation", 0.0))

        return WeatherOut(
            temperature_c=temp,
            humidity=humidity,
            wind_kph=wind,
            rain_mm=rain,
            condition="Partly Cloudy",
        )

    except Exception:
        
        return WeatherOut(
            temperature_c=30.0,
            humidity=45.0,
            wind_kph=10.0,
            rain_mm=0.0,
            condition="Sunny (fallback)",
        )
