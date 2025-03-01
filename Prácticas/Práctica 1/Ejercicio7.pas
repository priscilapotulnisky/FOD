program ejercicio7;
type
  novela = record
	codigo: integer;
	nombre:string;
	genero: string;
	precio: real;
  end;
  
  archivo = file of novela;
  
procedure leer(var n: novela);
begin
  write('Codigo: ');
  readln(n.codigo);
  if(n.codigo <> -1) then begin
    write('-Nombre: ');
    readln(n.nombre);
    write('Precio: ');
	readln(n.precio);
	write('Genero: ');
	readln(n.genero);
  end;
end;
procedure cargar(var a: archivo);
var
  txt: Text;
  n: novela;
begin
  assign(txt, 'novelas.txt');
  reset(txt);
  rewrite(a);
  while(not eof(txt)) do begin
    readln(txt, n.codigo, n.precio, n.genero);
    readln(txt, n.nombre);
    write(a, n);
  end;
  close(a);
  close(txt);
end;

procedure agregar(var a: archivo);
var
  n: novela;
  num: integer;
begin
  num:= 1;
  reset(a);
  while(num <> 0) do begin
    seek(a, filesize(a));
    leer(n);
    write(a, n);
    write('Ingrese 0 para salir, cualquier otro numero para seguir agregando novelas.');
    readln(num);
  end;
  close(a);
end;
 
procedure modificar(var a: archivo);
var
  n: novela;
  id: integer;
  encontre: boolean;
begin
  encontre:= false;
  write('Ingrese el codigo de la novela que quiere modificar: ');
  readln(id);
  reset(a);
  while(not eof(a)) and (encontre = false) do begin
     read(a, n);
     if(n.codigo = id) then begin
		writeln('----Ingrese los nuevos datos----');
		leer(n);
		seek(a, filepos(a) - 1);
		write(a, n);
		encontre:= true;
     end;
   end;
   close(a);
   if(encontre) then
     writeln('Los datos fueron modificados correctamente')
   else
     writeln('La novela no existe.');
end;

procedure imprimir(var a: archivo);
var
  n: novela;
begin
  reset(a);
  while(not eof(a)) do begin
    read(a, n);
    writeln(n.codigo, n.nombre, n.genero, n.precio);
  end;
  close(a);
end;

procedure menu(var a: archivo);
var
  opcion: integer;
begin
  writeln('----INGRESE UNA OPCION----');
  writeln('1) Para agregar novelas.');
  writeln('2) Para modificar una novela.');
  writeln('3) Para imprimir.');
  writeln('4) Para finalizar el programa.');
  readln(opcion);
  while(opcion <> 4) do begin
    case(opcion) of
      1: agregar(a);
      2: modificar(a);
      3: imprimir(a);
    end;
    writeln('----INGRESE UNA OPCION----');
	writeln('1) Para agregar novelas.');
	writeln('2) Para modificar una novela.');
	writeln('3) Para imprimir.');
	writeln('4) Para finalizar el programa.');
	readln(opcion);
  end;
end;

var
  a: archivo;
  nombreFisico: string;
begin
  write('Ingrese el nombre fisico del archivo: '); //P1.ej6
  readln(nombreFisico);
  assign(a, nombreFisico);
  cargar(a);
  menu(a);
end.
