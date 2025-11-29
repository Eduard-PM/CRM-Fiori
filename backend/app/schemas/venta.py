from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime
from typing import List, Optional


# -----------------------
# Detalle para crear venta
# -----------------------
class ItemVentaCreate(BaseModel):
    id_producto: int = Field(..., gt=0)
    cantidad: int = Field(..., gt=0)


# -----------------------
# Payload para registrar venta
# -----------------------
class VentaCreate(BaseModel):
    id_cliente: int = Field(..., gt=0)
    items: List[ItemVentaCreate]


# -----------------------
# Salida: Detalle de venta
# -----------------------
class DetalleVentaOut(BaseModel):
    id: int
    id_producto: int
    cantidad: int
    precio_unitario: float
    subtotal: float

    model_config = ConfigDict(from_attributes=True)


# -----------------------
# Salida: Venta completa
# -----------------------
class VentaOut(BaseModel):
    id: int
    id_cliente: int
    fecha_venta: datetime
    total: float
    detalles: Optional[List[DetalleVentaOut]]

    model_config = ConfigDict(from_attributes=True)


# -----------------------
# Salida: lista de ventas
# -----------------------
class VentaListOut(BaseModel):
    id: int
    id_cliente: int
    fecha_venta: datetime
    total: float

    model_config = ConfigDict(from_attributes=True)
