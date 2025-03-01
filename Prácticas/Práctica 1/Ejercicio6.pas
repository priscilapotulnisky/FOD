program ejercicio6;
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


procedure leer(var c: celular);
begin
  write('-Codigo: ');
  readln(c.codigo);
  if(c.codigo <> -1) then begin
    write('Nombre: ');
    readln(c.nombre);
    write('Descripcion: ');
    readln(c.descripcion);
    write('Marca: ');
    readln(c.marca);
    write('Precio: ');
    readln(c.precio);
    write('Stock minimo: ');
    readln(c.stockMinimo);
    write('Stock Disponible: ');
    readln(c.stockDisponible);
    writeln('--------------------');
  end;
end;

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

procedure agregar(var a: archivo);
var
  c: celular;
  num: integer;
begin
  num:= 1;
  reset(a);
  while(num <> 0) do begin
    seek(a, filesize(a));
    leer(c);
    write(a,c);
    writeln('Ingrese 0 si quiere dejar de agregar celulares, en caso contrario presione cualquier otro numero.');
    readln(num);
  end;
  close(a);  
end;

procedure modificarStock(var a: archivo);
var
  c: celular;
  id: integer;
  encontre: boolean;
begin
  encontre:= false;
  write('Ingrese el codigo del celular: ');
  readln(id);
  reset(a);
  while(not eof(a)) and (encontre = false) do begin
    read(a, c);
    if(c.codigo = id) then begin
      encontre:= true;
      write('Ingrese el nuevo stock: ');
      readln(c.stockDisponible);
      seek(a, filepos(a) - 1);
      write(a, c);
    end;
  end;
  if(encontre) then
    writeln('Datos modificados')
  else
    writeln('El celular no existe.');
end;

procedure exportarSinStock(var a: archivo);
var
  c: celular;
  txt: Text;
begin
  reset(a);
  assign(txt, 'SinStock.txt');
  rewrite(txt);
  while(not eof(a)) do begin
    read(a,c);
    if(c.stockDisponible = 0) then begin
      writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);
      writeln(txt, c.stockDisponible, ' ', c.stockMinimo, ' ', c.descripcion);
      writeln(txt, c.nombre);
    end;
  end;
  close(txt);
  close(a);
end;
    

procedure menu(var a: archivo);
var
  opcion: integer;
begin
  writeln('-----Ingrese una opcion-----');
  writeln('1) Para listar en pantalla aquellos celulares que tienen un stock menor al stock minimo');
  writeln('2) Para listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
  writeln('3) Para exportar el archivo a .txt');
  writeln('4) Para agregar uno o mas celulares');
  writeln('5) Para modificar el stock de un celular dado.');
  writeln('6) Para exportar el contenido de los celulares sin stock.');
  writeln('7) Para finalizar.');
  readln(opcion);
  while(opcion <> 7) do begin
    case(opcion) of
      1: MenorStock(a);
      2: buscarCadena(a);
      3: exportar(a);
      4: agregar(a);
      5: modificarStock(a);
      6: exportarSinStock(a);
    end;
    writeln('-----Ingrese una opcion-----');
	writeln('1) Para listar en pantalla aquellos celulares que tienen un stock menor al stock minimo');
	writeln('2) Para listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
	writeln('3) Para exportar el archivo a .txt');
	writeln('4) Para agregar uno o mas celulares');
	writeln('5) Para modificar el stock de un celular dado.');
	writeln('6) Para exportar el contenido de los celulares sin stock.');
	writeln('7) Para finalizar.');
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
