program ejercicio4;
const 
  valorAlto = 'ZZZ';
type
  informacion = record
    nombreProvincia: string;
    cantPersonas: integer;
    totalEncuestados: integer;
  end;
  
  resumen = record
    nombreProvincia: string; 
    codLocalidad: integer;
    cantPersonas: integer;
    cantEncuestados: integer;
  end;
  
  archivoMaestro = file of informacion;
  archivoDetalle = file of resumen;
  
procedure cargarMaestro(var aMaestro: archivoMaestro);
var
  txt: Text;
  i: informacion;
begin
  assign(txt, 'P2.ej4-maestro.txt');
  reset(txt);
  rewrite(aMaestro);
  while(not eof(txt)) do begin
    readln(txt, i.cantPersonas, i.totalEncuestados, i.nombreProvincia);
    write(aMaestro, i);
  end;
  close(aMaestro);
  close(txt);
  writeln('Maestro cargado.');
end;

procedure cargarDetalle(var aDetalle: archivoDetalle; ruta: string);
var
  txt: Text;
  r: resumen;
begin
  assign(txt, ruta);
  reset(txt);
  rewrite(aDetalle);
  while(not eof(txt)) do begin
    readln(txt, r.codLocalidad, r.cantPersonas, r.cantEncuestados, r.nombreProvincia);
    write(aDetalle, r);
  end;
  close(aDetalle);
  close(txt);
  writeln('Detalle cargado.');
end;

procedure leer(var aDetalle: archivoDetalle; var r: resumen);
begin
  if(not eof(aDetalle)) then
    read(aDetalle, r)
  else
    r.nombreProvincia:= valorAlto;
end;

procedure minimo(var a1: archivoDetalle; var a2: archivoDetalle; var r1: resumen; var r2: resumen; var min: resumen);
begin
  if(r1.nombreProvincia <= r2.nombreProvincia) then begin
    min:= r1;
    leer(a1, r1);
  end
  else begin
    min:= r2;
    leer(a2, r2);
  end;
end;

procedure actualizar(var aMaestro: archivoMaestro; var a1: archivoDetalle; var a2: archivoDetalle);
var
  r1: resumen;
  r2: resumen;
  min: resumen;
  i: informacion;
  
begin
  reset(aMaestro);
  reset(a1);
  reset(a2);
  leer(a1, r1);
  leer(a2, r2);
  minimo(a1, a2, r1, r2, min);
  while(min.nombreProvincia <> valorAlto) do begin
    writeln('primer while');
    read(aMaestro, i);
    while(min.nombreProvincia <> i.nombreProvincia) do
      read(aMaestro, i);
    while(min.nombreProvincia = i.nombreProvincia) do begin
      i.cantPersonas:= i.cantPersonas + min.cantPersonas;
      i.totalEncuestados:= i.totalEncuestados + min.cantEncuestados;
      minimo(a1, a2, r1, r2, min);
    end;
    seek(aMaestro, filepos(aMaestro) - 1);
    write(aMaestro, i);
  end;
  close(a2);
  close(a1);
  close(aMaestro);
  writeln('Actualizacion completa');
end;

procedure imprimir(var aMaestro: archivoMaestro);
var
  i: informacion;
begin
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, i);
    writeln(i.cantPersonas, ' ', i.totalEncuestados, ' ', i.nombreProvincia);
  end;
  close(aMaestro);
end;

var
  aMaestro: archivoMaestro;
  a1: archivoDetalle;
  a2: archivoDetalle;
begin
  assign(aMaestro, 'P2.ej4-maestro.dat');
  assign(a1, 'P2.ej4-detalle1.dat');
  assign(a2, 'P2.ej4-detalle2.dat');
  cargarMaestro(aMaestro);
  cargarDetalle(a1, 'P2.ej4-detalle1.txt');
  cargarDetalle(a2, 'P2.ej4-detalle2.txt');
  actualizar(aMaestro, a1, a2);
  imprimir(aMaestro);
end.
  
