from pydantic import BaseModel
from datetime import datetime

class ClienteBase(BaseModel):
    nombre: str
    telefono: str | None = None
    tipo_cliente: str
    frecuencia_compra: str | None = None
    direccion: str | None = None

class ClienteCreate(ClienteBase):
    pass

class Cliente(ClienteBase):
    id: int
    fecha_registro: datetime

    class Config:
        orm_mode = True
