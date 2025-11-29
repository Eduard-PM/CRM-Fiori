from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text, select
from sqlalchemy.orm import selectinload

from app.models.venta import Venta
from app.models.detalle_venta import DetalleVenta
from app.schemas.venta import VentaCreate


# -------------------------
# Validar cliente
# -------------------------
async def cliente_existe(db: AsyncSession, id_cliente: int) -> bool:
    r = await db.execute(
        text("SELECT 1 FROM clientes WHERE id = :id"),
        {"id": id_cliente}
    )
    return r.scalar() is not None


# -------------------------
# Obtener producto con stock
# -------------------------
async def obtener_producto(db: AsyncSession, id_producto: int):
    r = await db.execute(
        text("""
            SELECT id, precio_unitario, stock_actual
            FROM productos
            WHERE id = :id
        """),
        {"id": id_producto}
    )
    return r.mappings().first()


# -------------------------
# Actualizar stock
# -------------------------
async def actualizar_stock(db: AsyncSession, id_producto: int, nuevo_stock: int):
    await db.execute(
        text("""
            UPDATE productos
            SET stock_actual = :st
            WHERE id = :id
        """),
        {"st": nuevo_stock, "id": id_producto}
    )


# -------------------------
# Registrar movimiento inventario
# -------------------------
async def registrar_movimiento(
    db: AsyncSession,
    id_producto: int,
    cantidad: int
):
    await db.execute(
        text("""
            INSERT INTO inventario_movimientos
                (id_producto, tipo_movimiento, cantidad, fecha_movimiento)
            VALUES (:p, 'SALIDA', :c, NOW())
        """),
        {"p": id_producto, "c": cantidad}
    )


# -------------------------
# REGISTRAR VENTA COMPLETA
# -------------------------
async def registrar_venta(db: AsyncSession, data: VentaCreate) -> Venta:

    # Validar cliente
    if not await cliente_existe(db, data.id_cliente):
        raise HTTPException(
            status_code=404,
            detail="El cliente no existe"
        )

    if not data.items:
        raise HTTPException(400, "La venta debe tener items")

    venta = Venta(id_cliente=data.id_cliente, total=0)

    total_venta = 0

    try:
        for item in data.items:
            producto = await obtener_producto(db, item.id_producto)

            if producto is None:
                raise HTTPException(404, f"Producto {item.id_producto} no existe")

            if producto["stock_actual"] < item.cantidad:
                raise HTTPException(
                    status_code=400,
                    detail=f"Stock insuficiente para producto {item.id_producto}"
                )

            # Subtotal
            subtotal = producto["precio_unitario"] * item.cantidad
            total_venta += subtotal

            detalle = DetalleVenta(
                id_producto=item.id_producto,
                cantidad=item.cantidad,
                precio_unitario=producto["precio_unitario"],
                subtotal=subtotal
            )

            venta.detalles.append(detalle)

            # Reducir stock
            nuevo_stock = producto["stock_actual"] - item.cantidad
            await actualizar_stock(db, item.id_producto, nuevo_stock)

            # Registrar movimiento
            await registrar_movimiento(db, item.id_producto, item.cantidad)

        venta.total = total_venta

        db.add(venta)
        await db.commit()

        await db.refresh(venta)
        await db.refresh(venta, attribute_names=["detalles"])

        return venta

    except Exception:
        await db.rollback()
        raise
