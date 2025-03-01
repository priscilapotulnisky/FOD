program ejercicio1;
type
  archivo = file of integer;
procedure cargarArchivo(var a: archivo);
var
  num: integer;
begin
  write('Ingrese el numero que quiere agregar al archivo: ');
  readln(num);
  rewrite(a);
  while(num <> 30000) do begin
    write(a, num);
    write('Ingrese el numero que quiere agregar al archivo: ');
    readln(num);
  end;
  close(a);
end;

procedure imprimirArchivo(var a: archivo);
var
  num: integer;
begin
  reset(a);
  while(not eof(a)) do begin
    read(a, num);
    writeln(num);
  end;
  close(a);
end;

var
  a: archivo; nombreFisico: string;
begin
  write('Ingrese un nombre fisico: '); //P1.ej1
  readln(nombreFisico);
  assign(a, nombreFisico);
  cargarArchivo(a);
  imprimirArchivo(a);
end.

