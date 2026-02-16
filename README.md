# Spring Boot CRUD API con Docker y AWS ECS

## 📋 Descripción
API REST CRUD simple construida con Spring Boot, dockerizada y desplegada en AWS ECS mediante CI/CD con GitHub Actions.

## 🚀 Características
- CRUD completo de productos
- Base de datos H2 en memoria
- Dockerizado
- CI/CD con GitHub Actions
- Despliegue en AWS ECS

## 🛠️ Tecnologías
- Java 17
- Spring Boot 3.2.3
- Maven
- Docker
- AWS ECR & ECS
- GitHub Actions



## 📦 Endpoints API

### GET /api/productos
Obtiene todos los productos.

### GET /api/productos/{id}
Obtiene un producto por ID.

### POST /api/productos
Crea un nuevo producto.
```json
{
    "nombre": "Producto 1",
    "descripcion": "Descripción del producto",
    "precio": 99.99,
    "cantidad": 10
}
