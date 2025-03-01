program ejercicio1;
const
  valorAlto = 9999;
type
  empleado = record
    codigo: integer;
    nombre: string;
    monto: real;
  end;
  
  archivo = file of empleado;
  
procedure leer(var a: archivo; var e: empleado);
begin
  if(not eof(a)) then 
    read(a, e)
  else
    e.codigo:= valorAlto;
end;

procedure cargarArchivo(var a: archivo);
var
  txt: Text;
  e: empleado;
begin
  rewrite(a);
  assign(txt, 'P2.ej1.txt');
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, e.codigo, e.monto, e.nombre);
    write(a, e);
  end;
  close(txt);
  close(a);
  writeln('Archivo cargado');
end;

procedure compactar(var a: archivo; var archivoCompactado: archivo);
var
  e: empleado;
  eCompactado: empleado;
begin
  reset(a);
  assign(archivoCompactado, 'P2.ej1-compactado.dat');
  rewrite(archivoCompactado);
  leer(a, e);
  while(e.codigo <> valorAlto) do begin
    eCompactado.codigo:= e.codigo;
    eCompactado.monto:= 0;
    eCompactado.nombre:= e.nombre;
    while(e.codigo <> valorAlto) and (e.codigo = eCompactado.codigo) do begin
      eCompactado.monto:= eCompactado.monto + e.monto;
      leer(a, e);
    end;
    write(archivoCompactado, eCompactado);
  end;
  close(archivoCompactado);
  close(a);
  writeln('Compactado');
end;

procedure imprimirArchivo(var archivoCompactado: archivo);
var
  e: empleado;
begin
  reset(archivoCompactado);
  while(not eof(archivoCompactado)) do begin
    read(archivoCompactado, e);
    writeln('Codigo: ', e.codigo, ' Nombre: ', e.nombre, ' Monto: ', e.monto:0:2);
  end;
  close(archivoCompactado);
end;

var
  a: archivo;
  archivoCompactado: archivo;
begin
  assign(a, 'P2.ej1.dat');
  cargarArchivo(a);
  compactar(a, archivoCompactado);
  imprimirArchivo(archivoCompactado);
end.
    


