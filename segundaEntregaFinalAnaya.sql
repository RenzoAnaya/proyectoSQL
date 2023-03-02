

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

create table IF NOT EXISTS presentacion (
idPresentacion INT auto_increment not null primary key,
descripcionPresentacion VARCHAR(40)
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
precioProducto numeric (10,2) not null,
costoProducto numeric (10,2) not null,
idCategoria INT not null,
idEstacionalidad INT not null,
idPresentacion INT not null,
foreign key (idCategoria) references categoria(idCategoria),
foreign key (idEstacionalidad) references estacionalidad(idEstacionalidad),
foreign key (idPresentacion) references presentacion(idPresentacion)
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

create table IF NOT EXISTS estado (
idStatus INT auto_increment not null primary key,
descripcionStatus varchar(40) not null
);

create table IF NOT EXISTS orden (
idOrder INT auto_increment not null primary key,
idUsuario INT not null,
idDelivery INT not null,
idStatus INT not null,
foreign key (idUsuario) references usuario(idUsuario),
foreign key (idDelivery) references delivery(idDelivery),
foreign key(idStatus) references estado(idStatus)
);

create table IF NOT EXISTS productosOrden (
idProductosOrden INT auto_increment not null primary key,
idOrder INT not null,
idProduct INT not null,
idTamano INT,
idMadurez INT,
cantidad numeric not null,
foreign key (idOrder) references orden(idOrder),
foreign key (idProduct) references producto(idProduct),
foreign key (idTamano) references tamano(idTamano),
foreign key (idMadurez) references madurez(idMadurez)
);



insert into usuario (nombre, apellido, telefono, mail, direccion) values
("Juan", "Dominguez", "947888444","reree@gmail.com", "Avenida Juan chavez 543"),
("Juana", "Martinez", "987654622","dfdfdf@gmail.com", "Jiron calua 333"),
("Elsa", "Bordelmar", "987654322","sdsdsd@gmail.com", "Calle gamarra 1010"),
("Jaime", "Perez", "987654623","hola@gmail.com", "Calle humberto cienaga 870"),
("Raul", "Lopez", "987654323","gfgdsf@gmail.com", "Avenida San Cristobal 2010");

insert into tamano (idTamano, descripcionTamano) values
(1, "Pequeño"),
(2, "Mediano"),
(3, "Grande");

insert into presentacion (idPresentacion, descripcionPresentacion) values
(1, "1 kilo"),
(2, "500gr"),
(3, "250gr"),
(4, "100gr");

insert into madurez (idMadurez, descripcionMadurez) values
(1, "Por madurar"),
(2, "Madura");

insert into estacionalidad (idEstacionalidad, descripcionEstacionalidad) values
(1, "Sí está en temporada"),
(2, "No está en temporada");

insert into categoria (idCategoria, descripcionCategoria) values
(1, "Fruta"),
(2, "Verdura"),
(3, "Fruto Seco");

insert into producto (idProduct, nombreProducto, imagenProducto, precioProducto, costoProducto, idCategoria, idEstacionalidad, idPresentacion) values
(1, "Fresa", "fkjdsnfkljsdhflk32497h","10","5","1", "2","2"),
(2, "Melón", "fdkjnsf987423nklj","10","4","2", "1","1"),
(3, "Camote", "dnmsa9d93whndojkw","2","1","2", "1","1"),
(4, "Palta", "dnsaidnas8dnlanm","17","10","1", "1","1"),
(5, "Maní", "dñasmd9swdsja9sdn","20","13","3", "1","4");

insert into stock (idStock, idProduct, numeroStock) values
(1, "1", "5"),
(2, "2", "7"),
(3, "3", "4"),
(4, "4", "5"),
(5, "5", "3");

insert into delivery (idDelivery, deliveryDate) values
(1, "2023-02-08"),
(2, "2023-02-09"),
(3, "2023-02-10");

insert into estado (idStatus, descripcionStatus) values
(1,"pendiente"),
(2,"terminado"),
(3,"con problemas");

insert into orden (idOrder, idUsuario, idDelivery, idStatus) values
(1, "2","1",1),
(2, "1","1",2),
(3, "3","2",1),
(4, "4","2",1),
(5, "5","2",2);

insert into productosOrden (idOrder, idProduct, idTamano, idMadurez, cantidad) values
("1","1", null, null, "1"),
("1","2", "2", null, "2"),
("1","3", null, null, "6"),
("1","4", "2", "1", "5"),
("2","1", null, null, "1"),
("2","3", null, null, "4"),
("2","4", "3", "2", "1"),
("3","2", "1", null, "3"),
("3","1", null, null, "1"),
("4","3", null, null, "2"),
("4","5", null, null, "1");


DELIMITER //
create procedure pedidosPendientes()
begin
select * from orden WHERE idStatus = 1 ;
end;
//



DELIMITER //
create trigger checkMail
before insert on usuario
for each row
begin
	if new.mail not like '%@%.%' then
    signal sqlstate'45000'
    set MESSAGE_TEXT="Correo inválido";
    end if;

end;
//

DELIMITER //
create trigger checkSimilarMail
before insert on usuario
for each row
begin
	if new.mail IN(select mail from usuario) then
    signal sqlstate'45000'
    set MESSAGE_TEXT="Correo ya existente";
    end if;

end;
//


DELIMITER //
create trigger checkPhoneNum
before insert on usuario
for each row
begin
	if new.telefono < 900000000 then
    signal sqlstate'45000'
    set MESSAGE_TEXT="Número inválido";
    end if;
end;
//

DELIMITER //
create trigger validPhone
before insert on usuario
for each row
begin
	if new.telefono not like '9%' then
    signal sqlstate'45000'
    set MESSAGE_TEXT="Número no válido en Perú";
    end if;
end;
//

DELIMITER //
create trigger checkPhone
before insert on usuario
for each row
begin
	if new.telefono IN(select telefono from usuario) then
    signal sqlstate'45000'
    set MESSAGE_TEXT="Número ya registrado";
    end if;

end;
//

DELIMITER //
create function diferenciaPrecio(costo numeric(10,2), precio numeric(10,2)) returns numeric(10,2)
deterministic
begin
declare dif numeric(10,2);
SET dif = precio-costo;

return dif;
end;
//


DELIMITER //
create function actualizarStock(num numeric(10)) returns varchar(20)
deterministic
begin
declare a numeric(10);
declare mensaje varchar(20);
declare min numeric(10);
set min = 3;
set a = num-min;

IF a>0
THEN
set mensaje = "Stock suficiente" ;
ELSE
set mensaje = "Comprar más" ;
END IF;
return mensaje;
end;
//


select costoProducto, precioProducto,
diferenciaPrecio(costoProducto, precioProducto) margen
from producto;

select stock.numeroStock, producto.nombreProducto
From stock
inner join producto on stock.idProduct=producto.idProduct;

select numeroStock, 
actualizarStock(numeroStock) actualizar
from stock;

create or replace view productosMasComprados as
select 
T1.nombreProducto, 
T2.cantidad cantidad
from producto T1
left join productosOrden T2
on T1.idProduct = T2.idProduct
order by cantidad desc;


call pedidosPendientes();

select * from productosMasComprados;
