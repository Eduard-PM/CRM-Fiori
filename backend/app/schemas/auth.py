from pydantic import BaseModel, EmailStr


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class RegisterRequest(BaseModel):
    nombre: str
    email: EmailStr
    password: str
    rol: str = "vendedor"  # admin / vendedor / supervisor


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: int
    rol: str
    nombre: str
