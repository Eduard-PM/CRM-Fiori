from pydantic import BaseModel, EmailStr, ConfigDict

# Input para crear usuario
class UsuarioCreate(BaseModel):
    nombre: str
    email: EmailStr
    password: str
    rol: str = "vendedor"   # rol por defecto

# Output para retornar usuario
class UsuarioOut(BaseModel):
    id: int
    nombre: str
    email: EmailStr
    rol: str

    model_config = ConfigDict(from_attributes=True)

# Login
class LoginInput(BaseModel):
    email: EmailStr
    password: str

# Output del token
class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
