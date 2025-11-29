# \# 📦 CRM Fiori – Sistema de Gestión Comercial (Flutter + FastAPI)

# 

# CRM Fiori es una aplicación completa para puntos de venta (POS) y gestión comercial.  

# Incluye módulos de autenticación, inventario, clientes y ventas con historial y detalle.

# 

# ---

# 

# \## 🚀 Tecnologías

# 

# \### Backend

# \- FastAPI

# \- Python 3.11+

# \- SQLAlchemy Async

# \- JWT Authentication

# \- PostgreSQL

# \- Uvicorn

# 

# \### Frontend

# \- Flutter 3.x

# \- Provider (estado)

# \- SharedPreferences (token)

# \- Material Design Widgets

# 

# ---

# 

# \## 📁 Estructura

# 

# \### 🔧 Backend

# backend/

# ├── app/

# │ ├── models/

# │ ├── schemas/

# │ ├── routers/

# │ ├── services/

# │ ├── utils/

# │ └── database.py

# └── main.py

# 

# shell

# Copiar código

# 

# \### 📱 Frontend

# frontend/

# ├── lib/

# │ ├── providers/

# │ ├── screens/

# │ ├── services/

# │ ├── models/

# │ └── main.dart

# 

# yaml

# Copiar código

# 

# ---

# 

# \## 🛠 Requisitos

# 

# \### Backend

# \- Python 3.11 o superior

# \- PostgreSQL instalado y corriendo

# \- Crear base de datos:  

# &nbsp; ```sql

# &nbsp; CREATE DATABASE crm\_fiori;

# Frontend

# Flutter 3.x instalado (flutter --version)

# 

# Android Studio o VSCode

# 

# Emulator o dispositivo físico

# 

# 🔧 Instalación Backend

# Entrar a la carpeta:

# 

# bash

# Copiar código

# cd backend

# Crear entorno virtual:

# 

# bash

# Copiar código

# python -m venv venv

# source venv/bin/activate  # Linux/Mac

# venv\\Scripts\\activate     # Windows

# Instalar dependencias:

# 

# bash

# Copiar código

# pip install -r requirements.txt

# Crear archivo .env:

# 

# ini

# Copiar código

# DATABASE\_URL=postgresql+asyncpg://USER:PASSWORD@localhost:5432/crm\_fiori

# SECRET\_KEY=supersecretkey

# ALGORITHM=HS256

# Ejecutar migraciones (si aplica):

# 

# bash

# Copiar código

# alembic upgrade head

# Correr API:

# 

# bash

# Copiar código

# uvicorn app.main:app --reload

# Backend disponible en:

# ➡ http://localhost:8000/docs (Swagger)

# 

# 📱 Instalación Frontend

# Entrar a la carpeta:

# 

# bash

# Copiar código

# cd frontend/crm\_fiori

# Obtener dependencias:

# 

# bash

# Copiar código

# flutter pub get

# Ejecutar:

# 

# bash

# Copiar código

# flutter run

# 🔑 Login por defecto

# pgsql

# Copiar código

# email: admin@crm.com

# password: 123456

# 🧪 Funciones principales

# ✔ Login con JWT

# ✔ Inventario (listar, crear, actualizar stock)

# ✔ Clientes (listado)

# ✔ Registrar venta con múltiples productos

# ✔ Historial de ventas

# ✔ Detalle de venta

# ✔ Dashboard con estadísticas

# ✔ Token persistente

# 🧩 Navegación

# Ruta	Pantalla

# /login	Login

# /home	Dashboard

# /clientes	Clientes

# /inventario	Inventario

# /ventas	Registrar Venta

# /ventasHistory	Historial

# /ventaDetalle/:id	Detalle de venta

