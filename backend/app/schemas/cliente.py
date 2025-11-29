from pydantic import BaseModel
from datetime import datetime
from typing import Optional

# Config base compatible con Pydantic v2
class ConfigFromORM(BaseModel):
    class Config:
        from_attributes = True   # reemplaza orm_mode


# =============================
# BASE
# =============================
class ClienteBase(BaseModel):
    nombre: str
    telefono: Optional[str] = None
    tipo_cliente: str
    frecuencia_compra: Optional[str] = None
    direccion: Optional[str] = None


# =============================
# CREATE (input)
# =============================
class ClienteCreate(ClienteBase):
    pass


# =============================
# OUTPUT (GET)
# =============================
class ClienteOut(ClienteBase, ConfigFromORM):
    id: int
    fecha_registro: datetime
