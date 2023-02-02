

create schema IF NOT EXISTS Compra;
use Compra;

create table IF NOT EXISTS usuario (
idUsuario INT auto_increment not null primary key,
nombre VARCHAR(40) not null,
apellido VARCHAR(40) not null,
telefono numeric not null,
mail VARCHAR(70) not null,
direccion VARCHAR(70) not null
);

create table IF NOT EXISTS tamano (
idTamano INT auto_increment not null primary key,
descripcionTamano VARCHAR(40)
);

create table IF NOT EXISTS madurez (
idMadurez INT auto_increment not null primary key,
descripcionMadurez VARCHAR(40)
);

create table IF NOT EXISTS estacionalidad (
idEstacionalidad INT auto_increment not null primary key,
descripcionEstacionalidad VARCHAR(40)
);

create table IF NOT EXISTS categoria (
idCategoria INT auto_increment not null primary key,
descripcionCategoria VARCHAR(40)
);

create table IF NOT EXISTS producto (
idProduct INT auto_increment not null primary key,
nombreProducto VARCHAR(40) not null,
imagenProducto VARCHAR(500) not null,
idCategoria INT not null,
idTamano INT,
idMadurez INT,
idEstacionalidad INT not null,
foreign key (idCategoria) references categoria(idCategoria),
foreign key (idTamano) references tamano(idTamano),
foreign key (idMadurez) references madurez(idMadurez),
foreign key (idEstacionalidad) references estacionalidad(idEstacionalidad)
);

create table IF NOT EXISTS stock (
idStock INT auto_increment not null primary key,
idProduct INT not null,
numeroStock numeric,
foreign key (idProduct) references producto(idProduct)
);

create table IF NOT EXISTS delivery (
idDelivery INT auto_increment not null primary key,
deliveryDate DATE not null
);

create table IF NOT EXISTS orden (
idOrder INT auto_increment not null primary key,
idUsuario INT not null,
idDelivery INT not null,
idProduct INT not null,
foreign key (idUsuario) references usuario(idUsuario),
foreign key (idDelivery) references delivery(idDelivery),
foreign key (idProduct) references producto(idProduct)
);


insert into usuario (nombre, apellido, telefono, mail, direccion) values
("Juan", "Dominguez", "947888444","juan@gmail.com", "Juan de tenorio 234");


select * from usuario


