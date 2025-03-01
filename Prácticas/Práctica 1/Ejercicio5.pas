program ejercicio5;
type
  celular = record
    codigo: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stockMinimo: integer;
    stockDisponible: integer;
  end;
  
  archivo = file of celular;

procedure cargarArchivo(var a: archivo);
var 
  txt: Text;
  c: celular;
begin
  assign(txt, 'celulares.txt');
  reset(txt);
  rewrite(a);
  while(not eof(txt)) do begin
    readln(txt, c.codigo, c.precio, c.marca);
    readln(txt, c.stockDisponible, c.stockMinimo, c.descripcion);
    readln(txt, c.nombre);
    write(a, c);
  end;
  close(a);
  close(txt);
end;

function menorStock(minimo: integer; disponible: integer):boolean;
begin
  if(disponible < minimo) then 
    menorStock:= true
  else
    menorStock:= false;
end;

procedure MenorStock(var a: archivo);
var
  c: celular;
begin
  reset(a);
  while(not eof(a)) do begin
    read(a, c);
    if(menorStock(c.stockMinimo, c.stockDisponible)) then begin
      write('- Codigo: ', c.codigo, ' Nombre: ', c.nombre,' Marca: ', c.marca);
      writeln();
    end;
  end;
  close(a);
end;

procedure buscarCadena(var a: archivo);
var
  cadena: string;
  ok: boolean;
  c: celular;
begin
  ok:= false;
  write('Ingrese la descripcion a buscar: ');
  readln(cadena);
  reset(a);
  while(not eof(a)) do begin
    read(a, c);
    if(pos(cadena, c.descripcion) <> 0) then begin
       writeln('Codigo: ', c.codigo, ', Precio: ', c.precio:0:2, ', Marca: ',c.marca,', Stock disponible: ', c.stockDisponible, ', Stock minimo: ', c.stockMinimo, ', Descripcion: ', c.descripcion, ', Nombre: ',c.nombre);
       ok:= true;
    end;
  end;
  if(ok = false) then
    writeln('Ninguna descripcion contiene la cadena de texto ingresada.');
  close(a);
end;

procedure exportar(var a: archivo);
var
  c: celular;
  txt: Text;
begin
  reset(a);
  assign(txt, 'celulares.txt');
  rewrite(txt);
  while(not eof(a)) do begin
    read(a, c);
    writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);
    writeln(txt, c.stockDisponible, ' ', c.stockMinimo, ' ', c.descripcion);
    writeln(txt, c.nombre);
  end;
  close(txt);
  close(a);
  writeln('Archivo exportado correctamente');
end;

procedure menu(var a: archivo);
var
  opcion: integer;
begin
  writeln('-----Ingrese una opcion-----');
  writeln('1) Para listar en pantalla aquellos celulares que tienen un stock menor al stock minimo');
  writeln('2) Para listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
  writeln('3) Para exportar el archivo a .txt');
  writeln('4) Para finalizar.');
  readln(opcion);
  while(opcion <> 4) do begin
    case(opcion) of
      1: MenorStock(a);
      2: buscarCadena(a);
      3: exportar(a);
    end;
    writeln('-----Ingrese una opcion-----');
    writeln('1) Para listar en pantalla aquellos celulares que tienen un stock menor al stock minimo');
    writeln('2) Para listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
    writeln('3) Para exportar el archivo a .txt');
    writeln('4) Para finalizar.');
	readln(opcion);
  end;
end;
var
  a: archivo;
  nombreFisico: string;
begin
  write('Ingrese el nombre del archivo fisico: ');
  readln(nombreFisico);
  assign(a, nombreFisico);
  cargarArchivo(a);
  menu(a);
end.
