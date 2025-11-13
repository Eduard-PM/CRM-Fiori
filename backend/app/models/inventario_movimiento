from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class InventarioMovimiento(Base):
    __tablename__ = "inventario_movimientos"

    id = Column(Integer, primary_key=True, index=True)
    id_producto = Column(Integer, ForeignKey("productos.id"))
    tipo_movimiento = Column(String, nullable=False)  # venta / ajuste
    cantidad = Column(Integer, nullable=False)
    fecha_movimiento = Column(DateTime, default=datetime.utcnow)

    producto = relationship("Producto", back_populates="movimientos")
