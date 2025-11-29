from pydantic import BaseModel
from datetime import datetime

class MovimientoBase(BaseModel):
    producto_id: int
    tipo: str          # "entrada" | "salida"
    cantidad: float
    motivo: str

class MovimientoCreate(MovimientoBase):
    pass

class MovimientoOut(MovimientoBase):
    id: int
    fecha: datetime

    class Config:
        from_attributes = True
