from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_db
from app.models.producto import Producto
from app.schemas.producto import ProductoCreate, ProductoUpdate, ProductoOut
from datetime import datetime
from app.utils.auth_middleware import require_role

router = APIRouter(prefix="/productos", tags=["Productos"])

# GET ALL
@router.get("/", response_model=list[ProductoOut])
async def obtener_productos(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto))
    return result.scalars().all()

# GET BY ID
@router.get("/{producto_id}", response_model=ProductoOut)
async def obtener_producto(producto_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto).where(Producto.id == producto_id))
    producto = result.scalar_one_or_none()

    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    return producto

# CREATE
@router.post("/", response_model=ProductoOut, dependencies=[Depends(require_role("admin"))])
async def crear_producto(data: ProductoCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Producto(**data.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

# UPDATE
@router.put("/{producto_id}", response_model=ProductoOut)
async def actualizar_producto(producto_id: int, data: ProductoUpdate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto).where(Producto.id == producto_id))
    producto = result.scalar_one_or_none()

    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    for k, v in data.dict().items():
        setattr(producto, k, v)

    producto.fecha_actualizacion = datetime.utcnow()

    await db.commit()
    await db.refresh(producto)
    return producto

# DELETE
@router.delete("/{producto_id}")
async def eliminar_producto(producto_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto).where(Producto.id == producto_id))
    producto = result.scalar_one_or_none()

    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    await db.delete(producto)
    await db.commit()

    return {"mensaje": "Producto eliminado correctamente"}
