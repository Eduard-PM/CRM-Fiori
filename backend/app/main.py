from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import engine
from app.models import Base

# importación de routers
from app.routers.productos import router as productos_router
from app.routers.clientes import router as clientes_router
from app.routers.ventas import router as ventas_router
from app.routers.movimientos import router as movimientos_router
from app.routers.auth import router as auth_router

app = FastAPI(title="CRM Fiori API")

# ============================
# CORS CONFIG
# ============================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],      
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================
# CREAR TABLAS AL INICIAR
# ============================
@app.on_event("startup")
async def startup_event():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

# ============================
# REGISTRO DE ROUTERS
# ============================
app.include_router(productos_router)
app.include_router(clientes_router)
app.include_router(ventas_router)
app.include_router(movimientos_router)
app.include_router(auth_router)

# ============================
# ENDPOINT BASE
# ============================
@app.get("/")
def root():
    return {"message": "CRM Fiori Backend funcionando 👌"}
