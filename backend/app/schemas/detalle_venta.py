from pydantic import BaseModel, ConfigDict


# -----------------------------
# Lo que sale en la respuesta
# -----------------------------
class DetalleVentaOut(BaseModel):
    id: int
    id_producto: int
    cantidad: int
    precio_unitario: float
    subtotal: float

    model_config = ConfigDict(from_attributes=True)
