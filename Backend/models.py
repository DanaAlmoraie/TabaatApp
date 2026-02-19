# backend/models.py

from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    Float,
    Date,
    ForeignKey,
)
from sqlalchemy.orm import relationship
from database import Base


# ===========================
#        USERS TABLE
# ===========================
class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)


    # نفس الأعمدة اللي في SQL
    location = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)

    role = Column(String, nullable=False)  # Farmer / Shopper
    created_at = Column(Date)              # نفس نوع الـ DATE اللي في الجدول

    farms = relationship(
        "Farm",
        back_populates="user",
        cascade="all, delete-orphan",
    )
    images = relationship(
        "FruitImage",
        back_populates="user",
        cascade="all, delete-orphan",
    )
    reminders = relationship(
        "Reminder",
        back_populates="user",
        cascade="all, delete-orphan",
    )
    


# ===========================
#        FARM TABLE
# ===========================
class Farm(Base):
    __tablename__ = "farms"

    farm_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False)
    name = Column(String, nullable=False)
    location = Column(String)
    is_open = Column(Boolean, default=True)

    user = relationship("User", back_populates="farms")
    fruits = relationship(
        "FarmFruit",
        back_populates="farm",
        cascade="all, delete-orphan",
    )
    reminders = relationship(
        "Reminder",
        back_populates="farm",
        cascade="all, delete-orphan",
    )


# ===========================
#        FRUIT TABLE
# ===========================
class Fruit(Base):
    __tablename__ = "fruits"

    fruit_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    fruit_type = Column(String, unique=True, nullable=False)

    farm_links = relationship(
        "FarmFruit",
        back_populates="fruit",
        cascade="all, delete-orphan",
    )
    images = relationship("FruitImage", back_populates="fruit")
    reminders = relationship("Reminder", back_populates="fruit")


# ===========================
#      FARM_FRUIT TABLE
# ===========================
class FarmFruit(Base):
    __tablename__ = "farm_fruits"

    farm_id = Column(Integer, ForeignKey("farms.farm_id", ondelete="CASCADE"), primary_key=True)
    fruit_id = Column(Integer, ForeignKey("fruits.fruit_id", ondelete="CASCADE"), primary_key=True)

    farm = relationship("Farm", back_populates="fruits")
    fruit = relationship("Fruit", back_populates="farm_links")


# ===========================
#     FRUIT IMAGE TABLE
# ===========================
class FruitImage(Base):
    __tablename__ = "fruit_images"

    image_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL"))
    fruit_id = Column(Integer, ForeignKey("fruits.fruit_id"))

    ripeness = Column(String)
    yield_production = Column(String)  # نفس اسم العمود في SQL
    image_url = Column(String)
    upload_date = Column(Date)
    is_saved = Column(Boolean, default=False)

    user = relationship("User", back_populates="images")
    fruit = relationship("Fruit", back_populates="images")
    nutrition = relationship(
        "NutritionalInfo",
        back_populates="image",
        uselist=False,
        cascade="all, delete-orphan",
    )
    reminders = relationship("Reminder", back_populates="image")


# ===========================
#   NUTRITION INFO TABLE
# ===========================
class NutritionalInfo(Base):
    __tablename__ = "nutritional_info"

    nutritional_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    image_id = Column(
        Integer,
        ForeignKey("fruit_images.image_id", ondelete="CASCADE"),
        unique=True,
    )

    energy = Column(Float)
    water = Column(Float)
    protein = Column(Float)
    total_fat = Column(Float)
    carbs = Column(Float)
    fiber = Column(Float)
    sugar = Column(Float)
    calcium = Column(Float)
    iron = Column(Float)

    image = relationship("FruitImage", back_populates="nutrition")


# ===========================
#        REMINDER TABLE
# ===========================
class Reminder(Base):
    __tablename__ = "reminders"

    reminder_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"))
    image_id = Column(Integer, ForeignKey("fruit_images.image_id"))
    farm_id = Column(Integer, ForeignKey("farms.farm_id"))
    fruit_id = Column(Integer, ForeignKey("fruits.fruit_id"))

    message = Column(String)
    is_read = Column(Boolean, default=False)
    date_sent = Column(Date)

    user = relationship("User", back_populates="reminders")
    image = relationship("FruitImage", back_populates="reminders")
    farm = relationship("Farm", back_populates="reminders")
    fruit = relationship("Fruit", back_populates="reminders")
