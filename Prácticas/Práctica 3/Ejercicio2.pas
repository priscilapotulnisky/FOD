program ejercicio2;
type
  asistente = record
    numero: integer;
    apellidoYnom: string;
    email: string;
    telefono: integer;
    dni: integer;
  end;
  
  archivo = file of asistente;

procedure leer(var a: asistente);
begin
  write('-Numero: ');
  readln(a.numero);
  if(a.numero <> -1) then begin
    write('Apellido y nombre: ');
    readln(a.apellidoYnom);
    write('Email: ');
    readln(a.email);
    write('Telefono: ');
    readln(a.telefono);
    write('Dni: ');
    readln(a.dni);
  end;
end;

procedure cargarArchivo(var arch: archivo);
var
  a: asistente;
begin
  rewrite(arch);
  leer(a);
  while(a.numero <> -1) do begin
    write(arch, a);
    leer(a);
  end;
  close(arch);
end;

function cumple(numero: integer):boolean;
begin
  if(numero < 1000) then
    cumple:= true
  else
    cumple:= false;
end;

procedure eliminacionLogica(var arch: archivo);
var
  a: asistente;
begin
  reset(arch);
  while(not eof(arch)) do begin
    read(arch, a);
    if(cumple(a.numero)) then begin
      a.apellidoYnom:= '@' + a.apellidoYnom;
      seek(arch, filepos(arch) - 1);
      write(arch, a);
    end;
  end;
  close(arch);
end;

procedure imprimir(var arch: archivo);
var
  a: asistente;
begin
  reset(arch);
  while(not eof(arch)) do begin
    read(arch, a);
    writeln(a.numero, ' ', a.apellidoYnom);
  end;
  close(arch);
end;

var
  a: archivo;
begin
  assign(a, 'P3.ej2.dat');
  cargarArchivo(a);
  eliminacionLogica(a);
  imprimir(a);
end.
