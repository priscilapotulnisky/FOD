program ejercicio4;
type
  empleado = record
     numero: integer;
     apellido: string;
     nombre: string;
     edad: integer;
     dni: integer;
   end;
   archivo = file of empleado;
   
procedure datosDeterminados(var nombreLogico: archivo);
var
  apellido: string;
  e:empleado;
begin
  write('-Apellido que busca: ');
  readln(apellido);
  while(not eof(nombreLogico)) do begin
    read(nombreLogico, e);
    if(e.apellido = apellido) then
      writeln('El apellido a buscar pertenece al empleado: ', apellido, ' ', e.nombre);
  end;
end;
procedure listaDeEmpleados(var nombreLogico: archivo);
var
  e:empleado;
begin
  while(not eof(nombreLogico)) do begin
    read(nombreLogico, e);
    writeln(e.numero,' ',e.nombre, ' ', e.apellido, ' ', e.edad, ' ',e.dni);
  end;
end;
procedure jubilados(var nombreLogico: archivo);
var
  e:empleado;
begin
  while(not eof(nombreLogico)) do begin
    read(nombreLogico, e);
    if(e.edad > 70) then
      writeln('-El empleado: ', e.nombre, '',e.apellido,' esta proximo a jubilarse.');
  end;
end; 
procedure leer(var e: empleado);
begin
  write('Apellido: ');
  readln(e.apellido);
  if(e.apellido <> 'fin') then begin
    write('Nombre: ');
    readln(e.nombre);
    write('Edad: ');
    readln(e.edad);
    write('Dni: ');
    readln(e.dni);
    write('Numero de empleado: ');
    readln(e.numero);
  end;
end;
procedure agregarEmpleado(var nombreLogico: archivo);
var
  e:empleado;
begin
  seek(nombreLogico, filesize(nombreLogico));
  leer(e);
  while(e.apellido <> 'fin') do begin
    write(nombreLogico, e);
    leer(e);
  end;
end;
procedure modificarEdad(var nombreLogico: archivo);
var
  e:empleado;
  numeroEmpleado: integer;
  ok: boolean;
begin
  ok:= false;
  write('Ingrese el numero del empleado que desea modificar la edad: ');
  readln(numeroEmpleado);
  while(not eof(nombreLogico) and (ok = false)) do begin
    read(nombreLogico, e);
    if(numeroEmpleado = e.numero) then begin
      write('Ingrese la nueva edad: ');
      readln(e.edad);
      seek(nombreLogico, filepos(nombreLogico)-1);
      write(nombreLogico, e);
      ok:= false;
    end;
  end;
  if(ok) then 
    writeln('La edad del empleado ', e.nombre, ' ', e.apellido, ' fue modificada correctamente.')
  else
    writeln('No hay un empleado con ese numero.'); 
end;
procedure exportarArchivo(var nombreLogico: archivo);
var
  e:empleado;
  txt: Text;
begin
  assign(txt, 'todos_empleados.txt');
  rewrite(txt);
  while(not eof(nombreLogico)) do begin
    read(nombreLogico, e);
    writeln(txt, e.numero, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.dni);
  end;
  close(txt);
end;
procedure exportarDni(var nombreLogico: archivo);
var
  txt: Text;
  e:empleado;
begin
  assign(txt, 'faltaDniEmpleado.txt');
  rewrite(txt);
  while(not eof(nombreLogico)) do begin
    read(nombreLogico, e);
    if(e.dni = 0) then
      writeln(txt, e.numero, ' ',e.apellido,' ', e.nombre, ' ', e.edad,' ',e.dni);
  end;
  close(txt);
end;
procedure menu(var nombreLogico: archivo);
var
  opcion: integer;
begin
  writeln('Ingrese una opcion: ');
  writeln('1: Para buscar un empleado por su apellido. ');
  writeln('2: Para listar todos los empleados. ');
  writeln('3: Para listar los empleados mayores de 70, proximos a jubilarse. ');
  writeln('4: Para agregar mas empleados.');
  writeln('5: Para modificar la edad de un empleado.');
  writeln('6: Para exportar el archivo.');
  writeln('7: Para exportar a los empleados sin dni. ');
  readln(opcion);
  case opcion of
    1: datosDeterminados(nombreLogico);
    2: listaDeEmpleados(nombreLogico);
    3: jubilados(nombreLogico);
    4: agregarEmpleado(nombreLogico);
    5: modificarEdad(nombreLogico);
    6: exportarArchivo(nombreLogico);
    7: exportarDni(nombreLogico);
  end;
end;
var
  nombreLogico: archivo;
  nombreFisico: string;
begin
  write('Ingrese el nombre fisico del archivo: ');
  readln(nombreFisico);
  assign(nombreLogico, nombreFisico);
  reset(nombreLogico);
  menu(nombreLogico);
  close(nombreLogico);
end.
