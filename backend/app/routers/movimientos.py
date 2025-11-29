from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.models.inventario_movimiento import InventarioMovimiento
from app.schemas.movimiento import MovimientoCreate, MovimientoOut

router = APIRouter(prefix="/movimientos", tags=["Movimientos"])

@router.post("/", response_model=MovimientoOut)
async def registrar_movimiento(data: MovimientoCreate, db: AsyncSession = Depends(get_db)):
    mov = InventarioMovimiento(**data.model_dump())
    db.add(mov)
    await db.commit()
    await db.refresh(mov)
    return mov
