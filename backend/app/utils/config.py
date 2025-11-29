from dotenv import load_dotenv
import os

load_dotenv()

class Settings:
    # DATABASE
    DATABASE_URL: str = os.getenv("DATABASE_URL")

    # JWT
    JWT_SECRET: str = os.getenv("JWT_SECRET", "supersecret123")
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # Legacy / optional
    SECRET_KEY: str = os.getenv("SECRET_KEY", "secret")
    ALGORITHM: str = "HS256"


settings = Settings()
