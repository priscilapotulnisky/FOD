program ejercicio2;
const
  valorAlto = 9999;
type
  maestro = record
    codigo: integer;
    apellido: string;
    nombre: string;
    cantCursadas: integer;
    cantFinal: integer;
  end;
  
  detalle = record
    codigo: integer;
    materia: integer; // 0 si aprobo la cursada, 1 si aprobo el final
  end;
  
  archivoMaestro = file of maestro;
  archivoDetalle = file of detalle;
  
procedure cargarMaestro(var aMaestro: archivoMaestro);
var
  m: maestro;
  txt: Text;
begin
  assign(txt, 'P2.ej2-maestro.txt');
  reset(txt);
  rewrite(aMaestro);
  while(not eof(txt)) do begin
    readln(txt, m.codigo, m.cantCursadas, m.cantFinal, m.apellido);
    readln(txt, m.apellido);
    write(aMaestro, m);
  end;
  close(aMaestro);
  close(txt);
end;

procedure cargarDetalle(var aDetalle: archivoDetalle);
var
  txt: Text;
  d: detalle;
begin
  assign(txt, 'P2.ej2-detalle.txt');
  reset(txt);
  rewrite(aDetalle);
  while(not eof(txt)) do begin
	readln(txt, d.codigo, d.materia);
	write(aDetalle, d);
  end;
  close(aDetalle);
  close(txt);
end;

procedure leer(var aDetalle: archivoDetalle; var d: detalle);
begin
  if(not eof(aDetalle)) then
    read(aDetalle, d)
  else
    d.codigo:= valorAlto;
end;

procedure actualizar(var aMaestro: archivoMaestro; var aDetalle: archivoDetalle);
var
  d: detalle;
  m: maestro;
begin
  reset(aMaestro);
  reset(aDetalle);
  leer(aDetalle, d);
  while(d.codigo <> valorAlto) do begin
	read(aMaestro, m);
	while(not eof(aMaestro)) and (m.codigo <> d.codigo) do
      read(aMaestro, m);
	while(d.codigo <> valorAlto) and (m.codigo = d.codigo) do begin
		if(d.materia = 0) then
		  m.cantCursadas:= m.cantCursadas + 1
		else begin
		  m.cantFinal:= m.cantFinal + 1;
		  m.cantCursadas:= m.cantCursadas - 1;
		end;
		leer(aDetalle, d);
    end;
    seek(aMaestro, filepos(aMaestro) - 1);
    write(aMaestro, m);
  end;
  close(aDetalle);
  close(aMaestro);
end;

function cumple(cantCursadas: integer; cantFinal: integer): boolean;
begin
  if(cantFinal > cantCursadas) then
    cumple:= true
  else
    cumple:= false;
end;

procedure reporte(var aMaestro: archivoMaestro);
var
  txt: Text;
  m: maestro;
begin
  assign(txt, 'P2.ej2-reporte.txt');
  rewrite(txt);
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, m);
	if(cumple(m.cantCursadas, m.cantFinal)) then
	  writeln(txt, m.codigo, ' ', m.cantCursadas, ' ', m.cantFinal, ' ', m.nombre, ' ', m.apellido);
  end;
  close(aMaestro);
  close(txt);
end;

var
  aMaestro: archivoMaestro;
  aDetalle: archivoDetalle;
begin
  assign(aMaestro, 'P2.ej2-maestro.dat');
  assign(aDetalle, 'P2.ej2-detalle.dat');
  cargarMaestro(aMaestro);
  cargarDetalle(aDetalle);
  actualizar(aMaestro, aDetalle);
  reporte(aMaestro);
end.
    
