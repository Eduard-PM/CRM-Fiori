from sqlalchemy import Column, Integer, DateTime, ForeignKey, Float
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Venta(Base):
    __tablename__ = "ventas"

    id = Column(Integer, primary_key=True, index=True)
    id_cliente = Column(Integer, ForeignKey("clientes.id"))
    fecha_venta = Column(DateTime, default=datetime.utcnow)
    total = Column(Float, default=0.0)

    cliente = relationship("Cliente", back_populates="ventas")
    detalles = relationship("DetalleVenta", back_populates="venta")

detalles = relationship(
    "DetalleVenta",
    back_populates="venta",
    cascade="all, delete-orphan",
    lazy="selectin"
)
