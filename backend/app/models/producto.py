from sqlalchemy import Column, Integer, String, Float, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Producto(Base):
    __tablename__ = "productos"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    categoria = Column(String, nullable=False)
    unidad_medida = Column(String, nullable=False)
    precio_unitario = Column(Float, nullable=False)
    stock_actual = Column(Integer, default=0)
    stock_minimo = Column(Integer, default=5)
    fecha_actualizacion = Column(DateTime, default=datetime.utcnow)

    detalle_ventas = relationship("DetalleVenta", back_populates="producto")
    movimientos = relationship("InventarioMovimiento", back_populates="producto")
