from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_db
from app.models.usuario import Usuario
from app.schemas.usuario import UsuarioCreate, UsuarioOut, LoginInput, LoginResponse
from app.utils.security import hash_password, verify_password, create_access_token
from app.utils.auth_middleware import get_current_user, require_role

router = APIRouter(prefix="/auth", tags=["Autenticación"])

# ======================================================
# (1) Crear usuario (solo admin)
# ======================================================
@router.post("/register", response_model=UsuarioOut)
async def register_user(
    data: UsuarioCreate,
    db: AsyncSession = Depends(get_db),
    user: Usuario = Depends(require_role("admin")),
):
    # Verificar email duplicado
    result = await db.execute(select(Usuario).where(Usuario.email == data.email))
    if result.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Email ya registrado")

    new_user = Usuario(
        nombre=data.nombre,
        email=data.email,
        password=hash_password(data.password),
        rol=data.rol
    )

    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)

    return new_user


# ======================================================
# (2) Login → devuelve JWT
# ======================================================
@router.post("/login", response_model=LoginResponse)
async def login(data: LoginInput, db: AsyncSession = Depends(get_db)):

    result = await db.execute(select(Usuario).where(Usuario.email == data.email))
    user = result.scalar_one_or_none()

    if not user or not verify_password(data.password, user.password):
        raise HTTPException(status_code=401, detail="Credenciales inválidas")

    token = create_access_token({"sub": str(user.id)})

    return LoginResponse(access_token=token)

# ======================================================
# (3) Obtener información del usuario logueado
# ======================================================
@router.get("/me", response_model=UsuarioOut)
async def get_me(current_user: Usuario = Depends(get_current_user)):
    return current_user
