from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import date

from app.database import get_db
from app.schemas.venta import VentaCreate, VentaOut, VentaListOut
from app.models.venta import Venta
from app.services.ventas import registrar_venta
from app.utils.auth_middleware import get_current_user, require_role

router = APIRouter(prefix="/ventas", tags=["Ventas"])


# ============================
# REGISTRAR VENTA  (SEGURA)
# ============================
@router.post(
    "/registrar",
    response_model=VentaOut,
    status_code=201,
    dependencies=[Depends(require_role("vendedor", "admin"))]
)
async def crear_venta(
    data: VentaCreate,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(get_current_user)
):
    return await registrar_venta(db, data)


# ============================
# LISTAR TODAS
# ============================
@router.get("/", response_model=list[VentaListOut])
async def listar(db: AsyncSession = Depends(get_db)):
    r = await db.execute(select(Venta))
    return r.scalars().all()


# ============================
# OBTENER POR ID
# ============================
@router.get("/{venta_id}", response_model=VentaOut)
async def obtener(venta_id: int, db: AsyncSession = Depends(get_db)):
    r = await db.execute(select(Venta).where(Venta.id == venta_id))
    venta = r.scalar_one_or_none()

    if not venta:
        raise HTTPException(404, "Venta no encontrada")

    return venta


# ============================
# BUSCAR POR CLIENTE
# ============================
@router.get("/cliente/{id_cliente}", response_model=list[VentaListOut])
async def ventas_por_cliente(id_cliente: int, db: AsyncSession = Depends(get_db)):
    q = select(Venta).where(Venta.id_cliente == id_cliente)
    r = await db.execute(q)
    return r.scalars().all()


# ============================
# BUSCAR POR FECHA
# ============================
@router.get("/fecha/{fecha}", response_model=list[VentaListOut])
async def ventas_por_fecha(fecha: date, db: AsyncSession = Depends(get_db)):
    q = select(Venta).where(Venta.fecha_venta.cast(date) == fecha)
    r = await db.execute(q)
    return r.scalars().all()


# ============================
# BUSCAR POR RANGO
# ============================
@router.get("/rango", response_model=list[VentaListOut])
async def ventas_por_rango(
    inicio: date,
    fin: date,
    db: AsyncSession = Depends(get_db)
):
    q = select(Venta).where(
        Venta.fecha_venta >= inicio,
        Venta.fecha_venta <= fin
    )
    r = await db.execute(q)
    return r.scalars().all()


# ============================
# LISTADO PAGINADO
# ============================
@router.get("/lista", response_model=list[VentaListOut])
async def listar_paginado(
    skip: int = 0,
    limit: int = 10,
    db: AsyncSession = Depends(get_db)
):
    q = select(Venta).offset(skip).limit(limit)
    r = await db.execute(q)
    return r.scalars().all()
