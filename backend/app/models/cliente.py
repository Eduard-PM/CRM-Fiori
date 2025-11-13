from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Cliente(Base):
    __tablename__ = "clientes"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    telefono = Column(String, nullable=True)
    tipo_cliente = Column(String, nullable=False)
    frecuencia_compra = Column(String, nullable=True)
    direccion = Column(String, nullable=True)
    fecha_registro = Column(DateTime, default=datetime.utcnow)

    ventas = relationship("Venta", back_populates="cliente")
