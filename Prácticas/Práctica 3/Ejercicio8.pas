program ejercicio8;
type
  distribucion = record
     nombre: string;
     anio: integer;
     numeroVersion: integer;
     cantDesarrolladores: integer;
     descripcion: string;
   end;
   
   archivo = file of distribucion;
   
procedure leer(var d: distribucion);
begin
  write('-Nombre: ');
  readln(d.nombre);
  write('-Anio: ');
  readln(d.anio);
  write('-NumeroVersion: ');
  readln(d.numeroVersion);
  write('Cantidad de desarrolladores: ');
  readln(d.cantDesarrolladores);
  write('-Descripcion: ');
  readln(d.descripcion);
end;
   
procedure cargarArchivo(var a: archivo);
var
  d: distribucion;
begin
  rewrite(a);
  d.cantDesarrolladores:= 0;
  write(a, d);
  leer(d);
  while(d.nombre <> 'fin') do begin
    write(a, d);
    leer(d);
  end;
  close(a);
end;
  

function existeDistribucion(var a: archivo; nombre: string): boolean;
var
  ok: boolean;
  d: distribucion;
begin
  reset(a);
  ok:= false;
  while(not eof(a)) and (ok = false)do begin
    read(a, d);
    if(d.nombre = nombre) then begin
      ok:= true;
      writeln(ok);
    end;
  end;
  close(a);
  existeDistribucion:= ok;
end;

procedure altaDistribucion(var a: archivo);
var
  d: distribucion;
  aux: distribucion;
  pos: integer;
begin
  leer(aux);
  if(existeDistribucion(a, aux.nombre)) then
    writeln('Ya existe esa distribucion')
  else
    reset(a);
    read(a, d);
    if(d.cantDesarrolladores < 0) then begin
      pos:= d.cantDesarrolladores * -1;
      seek(a, pos);
      read(a, d);
      seek(a, filepos(a) -1);
      write(a, aux);
      seek(a, 0);
      write(a, d);
    end
    else begin
      seek(a, filesize(a));
      write(a, aux);
    end;
end;

procedure bajaDistribucion(var a: archivo);
var
  d: distribucion;
  nombre: string;
  aux: distribucion;
  ok: boolean;
  pos: integer;
begin
  ok:= false;
  write('Ingrese el nombre de la distribucion que quiere dar de baja: ');
  readln(nombre);
  if(existeDistribucion(a, nombre)) then begin
    reset(a);
    read(a, aux);
    while(not eof(a)) and (ok = false) do begin
      read(a, d);
      if(d.nombre = nombre) then begin
        ok:= true;
        pos:= (filepos(a) -1) * - 1;
        seek(a, pos * -1);
        write(a, aux);
        seek(a, 0);
        d.cantDesarrolladores:= pos;
        write(a, d);
      end;
    end;
    close(a);
  end 
  else begin
    writeln('La distribucion no existe');
  end;
end;

procedure menu(var a: archivo);
var
  opcion: integer;
begin
  writeln('---Ingrese una opcion---');
  writeln('1) Para agregar una distribucion');
  writeln('2) Para eliminar una distribucion');
  writeln('3) Para finalizar el programa');
  readln(opcion);
  while(opcion <> 3) do begin
    case (opcion ) of
      1: altaDistribucion(a);
      2: bajaDistribucion(a);
    end;
    writeln('---Ingrese una opcion---');
    writeln('1) Para agregar una distribucion');
    writeln('2) Para eliminar una distribucion');
    readln(opcion);
  end;
end;

procedure imprimir(var a: archivo);
var
  d: distribucion;
begin
  reset(a);
  while(not eof(a)) do begin
    read(a, d);
    writeln(d.cantDesarrolladores);
  end;
  close(a);
end;

var
 a: archivo;
begin
  assign(a, 'P3.ej8.dat');
  cargarArchivo(a);
  menu(a);
  imprimir(a);
end.
        
    

