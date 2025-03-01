program ejercicio6;
type
  prenda = record
    codigo: integer;
    descripcion: string;
    color: string;
    tipo: string;
    stock: integer;
    precio: real;
  end;
  
  archivoMaestro = file of prenda;
  archivoDetalle = file of integer; //solo contiene el codigo (integer)

procedure maestroDisponible(var maestro: archivoMaestro);
var
  txt: Text;
  p:prenda;
begin
  assign(txt, 'maestroPrenda.txt');
  assign(maestro, 'maestroPrenda.dat');
  reset(txt);
  rewrite(maestro);
  while(not eof(txt)) do begin
    readln(txt, p.codigo, p.stock, p.precio, p.descripcion);
    readln(txt, p.color);
    readln(txt, p.tipo);
    write(maestro, p);
  end;
  close(maestro);
  close(txt);
end;

procedure detalleDisponible(var detalle: archivoDetalle);
var
  cod: integer;
  txt: Text;
begin
  assign(txt, 'detallePrenda.txt');
  assign(detalle, 'detallePrenda.dat');
  reset(txt);
  rewrite(detalle);
  while(not eof(txt)) do begin
    readln(txt, cod);
    write(detalle, cod);
  end;
  close(detalle);
  close(txt);
end;

procedure darBaja(var maestro: archivoMaestro; var detalle: archivoDetalle);
var
  p: prenda;
  codigo: integer;
begin
  p.codigo:= 0; //registro de cabecera. Primer posicion en el archivo maestro
  reset(maestro);
  reset(detalle);
  while(not eof(detalle)) do begin
    read(detalle, codigo);
    seek(maestro, 0); //siempre volvemos al inicio porque los archivos no estan ordenados
    while(codigo <> p.codigo) do
      read(maestro, p);
    p.stock:= -1;  //si encuentro el registro a eliminar, le pongo la marca logica
    seek(maestro, filepos(maestro) - 1);
    write(maestro, p);
  end;
  close(detalle);
  close(maestro);
  writeln('Se han eliminado los elementos correctamente.');
end;

procedure bajaFisica(var maestro: archivoMaestro; var nuevoMaestro: archivoMaestro);
var
  p: prenda;
begin
  reset(maestro);
  assign(nuevoMaestro, 'nuevoMaestro.dat');
  rewrite(nuevoMaestro);
  while(not eof(maestro)) do begin
    read(maestro, p);
    if(p.stock >= 0) then
      write(nuevoMaestro, p);
  end;
  close(nuevoMaestro);
  close(maestro);
  erase(maestro);
  rename(nuevoMaestro, 'maestroPrenda.dat');
end;

procedure imprimirArchivo(var maestro: archivoMaestro);
var
  p: prenda;
begin
  reset(maestro);
  while(not eof(maestro)) do begin
    read(maestro, p);
    writeln(p.codigo,' ', p.descripcion,' ', p.stock,' ', p.precio:0:2); //solo algunos datos
  end;
  close(maestro);
end;

var
  maestro: archivoMaestro;
  detalle: archivoDetalle;
  maestroNuevo: archivoMaestro;
begin
  maestroDisponible(maestro);
  detalleDisponible(detalle);
  darBaja(maestro, detalle);
  writeln('============ ARCHIVO MAESTRO ANTES ============');
  imprimirArchivo(maestro);
  bajaFisica(maestro, maestroNuevo);
  writeln('============ ARCHIVO MAESTRO DESPUES ============');
  imprimirArchivo(maestroNuevo);
end.
