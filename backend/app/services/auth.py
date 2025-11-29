from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException

from app.models.usuario import Usuario
from app.utils.security import verify_password, hash_password, create_access_token


async def authenticate_user(db: AsyncSession, email: str, password: str):
    q = select(Usuario).where(Usuario.email == email)
    result = await db.execute(q)
    user = result.scalar_one_or_none()

    if not user:
        raise HTTPException(400, "Usuario no encontrado")

    if not verify_password(password, user.password):
        raise HTTPException(400, "Contraseña incorrecta")

    token = create_access_token({
        "user_id": user.id,
        "rol": user.rol
    })

    return token, user


async def register_user(db: AsyncSession, data):
    # Validar que no exista
    q = select(Usuario).where(Usuario.email == data.email)
    result = await db.execute(q)
    existing = result.scalar_one_or_none()

    if existing:
        raise HTTPException(400, "El email ya está registrado")

    hashed = hash_password(data.password)

    user = Usuario(
        nombre=data.nombre,
        email=data.email,
        password=hashed,
        rol=data.rol
    )

    db.add(user)
    await db.commit()
    await db.refresh(user)

    return user
