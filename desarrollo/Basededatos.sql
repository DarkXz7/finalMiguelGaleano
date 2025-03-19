CREATE DATABASE IF NOT EXISTS Kamiapp; 
USE Kamiapp;

-- Tabla Roles
CREATE TABLE IF NOT EXISTS Roles (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    nombreRol VARCHAR(100) NOT NULL
);

-- Tabla Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombreApellido VARCHAR(255) NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(255) NOT NULL UNIQUE,
    imagenPerfil VARCHAR(255) NOT NULL
);

-- Tabla UsuariosRoles (Tabla intermedia para la relación muchos a muchos)
CREATE TABLE IF NOT EXISTS UsuariosRoles (
    idUsuario INT NOT NULL,
    idRol INT NOT NULL,
    PRIMARY KEY(idUsuario, idRol),
    CONSTRAINT fk_UsuariosRoles_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_UsuariosRoles_Roles FOREIGN KEY(idRol) REFERENCES Roles(idRol) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla MetodosPago
CREATE TABLE IF NOT EXISTS MetodosPago (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL
);

-- Tabla Categorias
CREATE TABLE IF NOT EXISTS Categorias (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL
);

-- Tabla Productos
CREATE TABLE IF NOT EXISTS Productos (
    idProducto INT PRIMARY KEY AUTO_INCREMENT,
    idCategoria INT NOT NULL,
    idVendedor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) UNSIGNED NOT NULL,
    descripcion TEXT NOT NULL,
    fotoProducto VARCHAR(255) NOT NULL,
    CONSTRAINT fk_Productos_Categorias FOREIGN KEY(idCategoria) REFERENCES Categorias(idCategoria) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_Productos_Usuarios FOREIGN KEY(idVendedor) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla Pedidos
CREATE TABLE IF NOT EXISTS Pedidos (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    hora TIME NOT NULL,
    fechaPedido DATE DEFAULT CURRENT_DATE NOT NULL,
    estado VARCHAR(100) NOT NULL,
    CONSTRAINT fk_Pedidos_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla PedidosProductos (Tabla intermedia para la relación muchos a muchos)
CREATE TABLE IF NOT EXISTS PedidosProductos (
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    precioUnitario DECIMAL(10, 2) UNSIGNED NOT NULL,
    PRIMARY KEY(idPedido, idProducto),
    CONSTRAINT fk_PedidosProductos_Pedidos FOREIGN KEY(idPedido) REFERENCES Pedidos(idPedido) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_PedidosProductos_Productos FOREIGN KEY(idProducto) REFERENCES Productos(idProducto) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla Suscripciones
CREATE TABLE IF NOT EXISTS Suscripciones (
    idSuscripcion INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    tipoSuscripcion VARCHAR(255) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    estado VARCHAR(100) NOT NULL,
    CONSTRAINT fk_Suscripciones_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla Facturas
CREATE TABLE IF NOT EXISTS Facturas (
    idFactura INT PRIMARY KEY AUTO_INCREMENT,
    idMetodoPago INT NOT NULL,
    idPedido INT NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    hora TIME NOT NULL DEFAULT CURRENT_TIME,
    total DECIMAL(10, 2) UNSIGNED NOT NULL,
    tipo ENUM('factura', 'comprobante') NOT NULL,
    estadoPago VARCHAR(100) NOT NULL,
    CONSTRAINT fk_Facturas_MetodosPago FOREIGN KEY(idMetodoPago) REFERENCES MetodosPago(idMetodoPago) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_Facturas_Pedidos FOREIGN KEY(idPedido) REFERENCES Pedidos(idPedido) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla DetallesFactura
CREATE TABLE IF NOT EXISTS DetallesFactura (
    idDetalleFactura INT PRIMARY KEY AUTO_INCREMENT,
    idFactura INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    precioUnitario DECIMAL(10, 2) UNSIGNED NOT NULL,
    subtotal DECIMAL(10, 2) UNSIGNED NOT NULL,
    CONSTRAINT fk_DetallesFactura_Facturas FOREIGN KEY(idFactura) REFERENCES Facturas(idFactura) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_DetallesFactura_Productos FOREIGN KEY(idProducto) REFERENCES Productos(idProducto) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla Chats
CREATE TABLE IF NOT EXISTS Chats (
    idChat INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    hora TIME NOT NULL,
    mensaje TEXT NOT NULL,
    CONSTRAINT fk_Chats_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla Direcciones
CREATE TABLE IF NOT EXISTS Direcciones (
    idDireccion INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    CONSTRAINT fk_Direcciones_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla ReviewsProductos
CREATE TABLE IF NOT EXISTS ReviewsProductos (
    idReview INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    idProducto INT NOT NULL,
    calificacion INT NOT NULL,
    comentario TEXT,
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT fk_ReviewsProductos_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ReviewsProductos_Productos FOREIGN KEY(idProducto) REFERENCES Productos(idProducto) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla CuponesDescuento
CREATE TABLE IF NOT EXISTS CuponesDescuento (
    idCupon INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL,
    descuento DECIMAL(10, 2) UNSIGNED NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    estado VARCHAR(100) NOT NULL
);

-- Tabla CuponesProductos (Tabla intermedia para la relación muchos a muchos)
CREATE TABLE IF NOT EXISTS CuponesProductos (
    idCupon INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    PRIMARY KEY(idCupon, idProducto),
    CONSTRAINT fk_CuponesProductos_CuponesDescuento FOREIGN KEY(idCupon) REFERENCES CuponesDescuento(idCupon) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_CuponesProductos_Productos FOREIGN KEY(idProducto) REFERENCES Productos(idProducto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla Pagos
CREATE TABLE IF NOT EXISTS Pagos (
    idPago INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    idMetodoPago INT NOT NULL,
    idPedido INT NOT NULL, -- Asocia el pago con un pedido
    fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    hora TIME NOT NULL DEFAULT CURRENT_TIME,
    monto DECIMAL(10, 2) UNSIGNED NOT NULL,
    estado VARCHAR(100) NOT NULL, -- Estado del pago (ej. 'Pagado', 'Pendiente')
    referenciaPasarela VARCHAR(255) NOT NULL, -- Identificador de la transacción en la pasarela
    CONSTRAINT fk_Pagos_Usuarios FOREIGN KEY(idUsuario) REFERENCES Usuarios(idUsuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_Pagos_MetodosPago FOREIGN KEY(idMetodoPago) REFERENCES MetodosPago(idMetodoPago) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_Pagos_Pedidos FOREIGN KEY(idPedido) REFERENCES Pedidos(idPedido) ON DELETE RESTRICT ON UPDATE CASCADE
);

