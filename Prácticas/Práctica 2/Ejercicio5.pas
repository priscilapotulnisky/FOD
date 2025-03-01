program ejercicio5;
const
  valorAlto = 9999;
  dimF = 3; // son 30
type
  producto = record
	codigo: integer;
	nombre: string;
	descripcion: string;
	stockDisponible: integer;
	stockMinimo: integer;
	precio: real;
  end;
  
  resumen = record
	codigo: integer;
	cantVendida: integer;
  end;
  
  archivoMaestro = file of producto;
  archivoDetalle = file of resumen;
  
  vectorArchivos = array[1..dimF] of archivoDetalle;
  vectorRegistros = array[1..dimF] of resumen;

procedure cargarMaestro(var aMaestro: archivoMaestro);
var
  txt: Text;
  p: producto;
begin
  assign(txt, 'P2.ej5-maestro.txt');
  reset(txt);
  rewrite(aMaestro);
  while(not eof(txt)) do begin
    readln(txt, p.codigo, p.precio, p.stockDisponible, p.stockMinimo, p.nombre);
    readln(txt, p.descripcion);
    write(aMaestro, p);
  end;
  close(aMaestro);
  close(txt);
end;

procedure cargarDetalle(var aDetalle: archivoDetalle);
var
  txt: Text;
  r: resumen;
  ruta: string;
begin
  write('Ingrese la ruta del archivo detalle binario: ');
  readln(ruta);
  assign(aDetalle, ruta);
  write('Ingrese la ruta del archivo de texto: ');
  readln(ruta);
  assign(txt, ruta);
  reset(txt);
  rewrite(aDetalle);
  while(not eof(txt)) do begin
	readln(txt, r.codigo, r.cantVendida);
	write(aDetalle, r);
  end;
  close(aDetalle);
  close(txt);
end;

procedure cargarVector(var v:vectorArchivos);
var 
  i: integer;
begin
  for i:= 1 to dimF do
    cargarDetalle(v[i]);
end;

procedure leer(var aDetalle: archivoDetalle; var r: resumen);
begin
  if(not eof(aDetalle)) then
    read(aDetalle, r)
  else
    r.codigo:= valorAlto;
end;

procedure minimo(var vArchivos: vectorArchivos; var vRegistros: vectorRegistros; var min: resumen);
var
  i: integer;
  pos: integer;
begin
  min.codigo:= valorAlto;
  for i:= 1 to dimF do begin
    if(vRegistros[i].codigo < min.codigo) then begin
      min:= vRegistros[i];
      pos:= i;
    end;
  end;
  if(min.codigo <> valorAlto) then 
    leer(vArchivos[pos], vRegistros[pos]);
end;

procedure actualizar(var vArchivos: vectorArchivos; var aMaestro: archivoMaestro);
var
  vRegistros: vectorRegistros;
  p: producto;
  i: integer;
  min: resumen;
begin
  reset(aMaestro);
  for i:= 1 to dimF do begin
    reset(vArchivos[i]);
    leer(vArchivos[i], vRegistros[i]);
  end;
  minimo(vArchivos, vRegistros, min);
  while(min.codigo <> valorAlto) do begin
    read(aMaestro, p);
    while(p.codigo <> min.codigo) do 
      read(aMaestro, p);
    while(p.codigo = min.codigo) do begin
      p.stockDisponible:= p.stockDisponible - min.cantVendida;
      minimo(vArchivos, vRegistros, min);
    end;
    seek(aMaestro, filepos(aMaestro) - 1);
    write(aMaestro, p);
  end;
  for i:= 1 to dimF do 
    close(vArchivos[i]);
  close(aMaestro);
end;

function cumple(stockDisponible: integer; stockMinimo: integer):boolean;
begin
  if(stockDisponible < stockMinimo) then
    cumple:= true
  else
    cumple:= false;
end;

procedure informar(var aMaestro: archivoMaestro);
var
  p: producto;
  txt: Text;
begin 
  assign(txt, 'P2.ej5-informe.txt');
  rewrite(txt);
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, p);
    writeln(txt, p.codigo, ' ', p.stockDisponible, ' ', p.stockMinimo, ' ', p.precio, ' ', p.nombre);
    writeln(txt, p.descripcion);
  end;
  close(aMaestro);
  close(txt);
end;

procedure imprimirMaestro(var aMaestro: archivoMaestro);
var
  p: producto;
begin
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, p);
    writeln(p.codigo, ' ', p.stockDisponible, ' ', p.nombre);
  end;
  close(aMaestro);
end;

var
  aMaestro: archivoMaestro;
  v: vectorArchivos;
begin
  assign(aMaestro, 'P2.ej5-maestro.dat');
  cargarMaestro(aMaestro);
  cargarVector(v);
  actualizar(v, aMaestro);
  informar(aMaestro);
  imprimirMaestro(aMaestro);
end.
    

