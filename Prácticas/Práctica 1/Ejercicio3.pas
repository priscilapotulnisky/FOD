program ejercicio3;
type
  empleado = record
    numero: integer;
    apellido: string;
    nombre: string;
    edad: integer;
    dni: integer;
  end;
  
  archivo = file of empleado;
  
procedure leer(var e: empleado);
begin
  write('-Apellido: ');
  readln(e.apellido);
  if(e.apellido <> 'fin') then begin
    write('-Nombre: ');
    readln(e.nombre);
    write('-Numero de empleado: ');
    readln(e.numero);
    write('-Edad: ');
    readln(e.edad);
    write('-DNI: ');
    readln(e.dni);
  end;
end;
  
procedure cargarArchivo(var a: archivo);
var
  e:empleado;
begin
  rewrite(a);
  leer(e);
  while(e.apellido <> 'fin') do begin
    write(a, e);
    leer(e);
  end;
  close(a);
end;

procedure listarPredeterminados(var a: archivo);
var
  e: empleado;
  nombre: string;
  apellido: string;
begin
  write('Ingrese el nombre a comparar: ');
  readln(nombre);
  write('Ingrese el apellido a comparar: ');
  readln(apellido);
  reset(a);
  while(not eof(a)) do begin
    read(a, e);
    if((nombre = e.nombre) or (apellido = e.apellido)) then begin
      writeln('-El dato ingresado coincide con el empleado: ');
      write(e.numero, ' ', e.nombre, ' ', e.apellido, ' ', e.edad, ' ',e.dni);
    end;
  end;
  close(a);
end;

procedure listarPorLinea(var a: archivo);
var
  e: empleado;
begin
  reset(a);
  while(not eof(a)) do begin
     read(a,e);
     writeln(e.numero, ' ', e.nombre, ' ', e.apellido, ' ', e.edad, ' ',e.dni);
  end;
  close(a);
end;

function cumple(edad: integer): boolean;
begin
  if(edad > 70) then
    cumple:= true
  else
    cumple:= false;
end;
procedure empleadosMayores(var a: archivo);
var
  e: empleado;
begin
  reset(a);
  writeln('Empleados mayores de 70: ');
  while(not eof(a)) do begin
    read(a, e);
    if(cumple(e.edad)) then
      writeln(e.numero, ' ', e.nombre, ' ', e.apellido, ' ', e.edad, ' ',e.dni);
  end;
  close(a);
end;

procedure menu(var a: archivo);
var
  opcion: integer;
begin
  writeln('-----Ingrese una opcion-----');
  writeln('1) Para listar en pantalla los empleados que tengan un nombre o apellido determinado.');
  writeln('2) Para listan en pantalla los empleados de a uno por linea.');
  writeln('3) Para listar los empleados proximos a jubilarse.');
  readln(opcion);
  while(opcion <> -1) do begin
    case(opcion) of
      1: listarPredeterminados(a);
      2: listarPorLinea(a);
      3: empleadosMayores(a);
    end;
    writeln('-----Ingrese una opcion-----');
    writeln('1) Para listar en pantalla los empleados que tengan un nombre o apellido determinado.');
    writeln('2) Para listan en pantalla los empleados de a uno por linea.');
    writeln('3) Para listar los empleados proximos a jubilarse.');
    readln(opcion);
  end;
end;

var
  a: archivo;
  nombreFisico: string;
begin
  write('Ingrese el nombre fisico del archivo: '); //P1.ej3
  readln(nombreFisico);
  assign(a, nombreFisico);
  cargarArchivo(a);
  menu(a);
end.
