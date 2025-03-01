program ejercicio3;
const
	valorAlto = 9999;
type
	producto = record
	  codigo: integer;
	  nombre: string;
	  precio: real;
	  stockActual: integer;
	  stockMinimo: integer;
	end;
	
	resumen = record
	  codigo: integer;
	  cantVendidas: integer;
	end;
	
	maestro = file of producto;
	detalle = file of resumen;

procedure cargarMaestro(var aMaestro: maestro);
var
  p: producto;
  txt: Text;
begin
  assign(txt, 'P2.ej3-maestro.txt');
  reset(txt);
  rewrite(aMaestro);
  while(not eof(txt)) do begin
	readln(txt, p.codigo, p.precio, p.stockActual, p.stockMinimo, p.nombre);
	write(aMaestro, p);
  end;
  close(aMaestro);
  close(txt);
end;

procedure cargarDetalle(var aDetalle: detalle);
var
  txt: Text;
  r: resumen;
begin
  assign(txt, 'P2.ej3-detalle.txt');
  reset(txt);
  rewrite(aDetalle);
  while(not eof(txt)) do begin
    readln(txt, r.codigo, r.cantVendidas);
    write(aDetalle, r);
  end;
  close(aDetalle);
  close(txt);
end;

procedure leer(var aDetalle: detalle; var r: resumen);
begin
  if(not eof(aDetalle)) then
    read(aDetalle, r)
  else
    r.codigo:= valorAlto;
end;
procedure actualizar(var aMaestro: maestro; var aDetalle: detalle);
var
  r: resumen;
  p: producto;
  
begin
  reset(aMaestro);
  reset(aDetalle);
  leer(aDetalle, r);
  while(r.codigo <> valorAlto) do begin
    read(aMaestro, p);
    while(p.codigo <> r.codigo) do 
      read(aMaestro, p);
    while(r.codigo = p.codigo) do begin //no tiene la condicion anterior por sus precondiciones
      p.stockActual:= p.stockActual - r.cantVendidas;
      leer(aDetalle, r);
    end;
    seek(aMaestro, filepos(aMaestro) - 1);
    write(aMaestro, p);
  end;
  close(aDetalle);
  close(aMaestro);
  writeln('Actualizacion completa');
end;

function stockMinimo(stockActual: integer; stockMin: integer): boolean;
begin
  if(stockActual < stockMin) then
    stockMinimo:= true
  else
    stockMinimo:= false;
end;

procedure listar(var aMaestro: maestro);
var
  p: producto;
  txt: Text;
begin
  assign(txt, 'P2.ej3-stock_minimo.txt');
  rewrite(txt);
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, p);
    if(stockMinimo(p.stockActual, p.stockMinimo)) then
      writeln(txt, p.codigo, ' ', p.precio, ' ', p.stockActual, ' ', p.stockMinimo, ' ', p.nombre);
  end;
  close(aMaestro);
  close(txt);
end;

var
  aMaestro: maestro;
  aDetalle: detalle;
begin
  assign(aMaestro, 'P2.ej3-maestro.dat');
  assign(aDetalle, 'P2.ej3-detalle.dat');
  cargarMaestro(aMaestro);
  cargarDetalle(aDetalle);
  actualizar(aMaestro, aDetalle);
  listar(aMaestro);
end.
