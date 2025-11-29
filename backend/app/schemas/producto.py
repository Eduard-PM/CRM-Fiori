from pydantic import BaseModel
from datetime import datetime

class ProductoBase(BaseModel):
    nombre: str
    categoria: str
    unidad_medida: str
    precio_unitario: float
    stock_actual: int
    stock_minimo: int

class ProductoCreate(ProductoBase):
    pass

class ProductoUpdate(ProductoBase):
    pass

class ProductoOut(ProductoBase):
    id: int
    fecha_actualizacion: datetime

    class Config:
        orm_mode = True
