program ejercicio6;
const 
  valorAlto = 9999;
  dimF = 3;
type
  detalle = record
    codigo: integer;
    fecha: string;
    tiempo: real;
  end;
  
  archivoMaestro = file of detalle; //En realidad no es necesario crear las dos instancias porque son exactamente el mismo tipo. Pero lo pongo porque es mas fácil de entender
  archivoDetalle = file of detalle;
  
  vectorArchivos = array [1..dimF] of archivoDetalle;
  vectorRegistros = array[1..dimF] of detalle;
  
procedure detallesQueSeDisponen(var aDetalle: archivoDetalle);
var
  txt: Text;
  d: detalle;
  ruta: string;
begin
  write('Ingrese el nombre del archivo binario: ');
  readln(ruta);
  assign(aDetalle, ruta);
  rewrite(aDetalle);
  write('Ingrese el nombre del archivo de texto: ');
  readln(ruta);
  assign(txt, ruta);
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, d.codigo, d.tiempo, d.fecha);
    write(aDetalle, d);
  end;
  close(txt);
  close(aDetalle);
  writeln('Archivo detalle cargado');
end;

procedure cargarVector(var v: vectorArchivos);
var
  i: integer;
begin
  for i:= 1 to dimF do 
    detallesQueSeDisponen(v[i]);
end;

procedure leer(var aDetalle: archivoDetalle; var dato: detalle);
begin
  if(not eof(aDetalle)) then
    read(aDetalle, dato)
  else
    dato.codigo:= valorAlto;
end;

procedure minimo(var v: vectorArchivos; var vRegistros : vectorRegistros; var min : detalle);
var
  i: integer;
  pos : integer;
begin
  min.codigo := valorAlto;
  min.fecha := 'ZZZZ';
  for i := 1 to dimF do begin
    if (vRegistros[i].codigo <= min.codigo) then begin
      min := vRegistros[i];
	  pos := i;
	end;
  end;
  if(min.codigo <> valorAlto)then
    leer(v[pos], vRegistros[pos]);
end; 

procedure crearArchivoMaestro(var aMaestro: archivoMaestro; var v: vectorArchivos);
var
  i: integer;
  d: detalle;
  vRegistros: vectorRegistros;
  min: detalle;
begin
  assign(aMaestro, 'archivoMaestroEj6.dat');
  rewrite(aMaestro);
  for i:= 1 to dimF do begin
    reset(v[i]);
    leer(v[i], d);
  end;
  minimo(v, vRegistros, min);
  while(min.codigo <> valorAlto) do begin
    d.codigo:= min.codigo;
    while(d.codigo = min.codigo) do begin
      d.fecha:= min.fecha;
      d.tiempo:= 0;
      while(d.codigo = min.codigo) and (d.fecha = min.fecha) do begin
        d.tiempo:= d.tiempo + min.tiempo;
        minimo(v, vRegistros, min);
      end;
      write(aMaestro, d);
    end;
  end;
  for i:= 1 to dimF do
    close(v[i]);
  close(aMaestro);
  writeln('Archivo maestro creado');
end;

procedure imprimirMaestro(var aMaestro: archivoMaestro);
var
  d: detalle;
begin
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, d);
    writeln('Codigo: ', d.codigo, ' Fecha: ', d.fecha, ' Tiempo total: ', d.tiempo:0:2);
  end;
  close(aMaestro);
end;

var
  aMaestro: archivoMaestro;
  v: vectorArchivos;
begin
  cargarVector(v);
  crearArchivoMaestro(aMaestro, v);
  imprimirMaestro(aMaestro);
end.
