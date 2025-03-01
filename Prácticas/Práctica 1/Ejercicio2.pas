program ejercicio2;
type
  archivo = file of integer;
procedure cargarArchivo(var a: archivo);
var
  num: integer;
begin
  write('Ingrese el numero que quiere agregar al archivo: ');
  readln(num);
  rewrite(a);
  while(num <> -1) do begin
    write(a, num);
    write('Ingrese el numero que quiere agregar al archivo: ');
    readln(num);
  end;
  close(a);
end;

procedure imprimirInforme(var a: archivo);
var
  num: integer;
  total: integer;
  cant: integer;
begin
  reset(a);
  total:= 0;
  cant:= 0;
  while(not eof(a)) do begin
    read(a, num);
    total:= total + num;
    cant:= cant + 1;
    if(num < 1500) then
      writeln(num);
  end;
  writeln('El promedio de los numeros del archivo es: ', total/cant:0:2);
  close(a);
end;

var
  a: archivo; nombreFisico: string;
begin
  write('Ingrese un nombre fisico: '); //P1.ej1
  readln(nombreFisico);
  assign(a, nombreFisico);
  cargarArchivo(a);
  imprimirInforme(a);
end.

