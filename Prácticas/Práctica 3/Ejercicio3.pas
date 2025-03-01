program ejercicio3;
type
  novela = record
    codigo: integer;
    genero: string;
    nombre: string;
    duracion: integer;
    director: string;
    precio: real;
  end;
  
  archivo = file of novela;
  
procedure leer(var n: novela);
begin
  write('Codigo: ');
  readln(n.codigo);
  if(n.codigo <> -1) then begin
    write('Genero: ');
    readln(n.genero);
    write('Nombre: ');
    readln(n.nombre);
    write('Duracion: ');
    readln(n.duracion);
    write('Director: ');
    readln(n.director);
    write('Precio: ');
    readln(n.precio);
  end;
end;

procedure cabecera(var n: novela);
begin
  n.codigo:= 0;
  n.nombre:= 'cabecera';
  n.genero:= '';
  n.director:= '';
  n.duracion:= 0;
  n.precio:= 0;
end;

procedure cargarArchivo(var a: archivo);
var
  n: novela;
begin
  rewrite(a);
  cabecera(n);
  write(a, n);
  leer(n);
  while(n.codigo <> -1) do begin
    write(a, n);
    leer(n);
  end;
  close(a);
end;

procedure agregarNovela(var a: archivo);
var
  n: novela;
  aux: novela;
  pos: integer;
begin
  reset(a);
  read(a, aux);
  leer(n);
  if(aux.codigo < 0) then begin
    pos:= aux.codigo * -1;
    seek(a, pos);
    read(a, aux);
    seek(a, filepos(a) - 1);
    write(a, n);
    seek(a, 0);
    write(a, aux);
  end
  else begin
    seek(a, filesize(a));
    write(a, n);
  end;
  close(a);
end;

procedure modificar(var a: archivo);
var
  n: novela;
  codigo: integer;
  ok: boolean;
begin
  ok:= false;
  write('Ingrese el codigo de la novela a modificar: ');
  readln(codigo);
  reset(a);
  while(not eof(a)) and (ok = false) do begin
    read(a, n);
    if(n.codigo = codigo) then begin
      ok:= true;
      leer(n);
      n.codigo:= codigo;
      seek(a, filepos(a) - 1);
      write(a, n);
    end;
  end;
  close(a);
  if(ok) then
    writeln('Modificado correctamente')
  else
    writeln('No se encuentra la novela');
end;
 
procedure eliminarNovela(var a: archivo);
var
   n: novela;
   aux: novela;
   codigo: integer;
   ok: boolean;
   pos: integer;
begin
  ok:= false;
  write('Ingrese el codigo de la novela que quiere eliminar: ');
  readln(codigo);
  reset(a);
  read(a, aux);
  while(not eof(a)) and (ok = false) do begin
    read(a, n);
    if(n.codigo = codigo) then begin
      pos:= filepos(a) - 1;
      seek(a, pos);
      write(a, aux);
      seek(a, 0);
      n.codigo:= pos * -1;
      write(a, n);
      ok:= true;
    end;
  end;
  if(ok) then
    writeln('Baja realizada correctamente. ')
  else
    writeln('No existe esa novela.');
end;

procedure listar(var a: archivo);
var
  txt: Text;
  n: novela;
begin
  assign(txt, 'P3.ej3-novelas.txt');
  rewrite(txt);
  reset(a);
  while(not eof(a)) do begin
    read(a, n);
    writeln(txt, n.codigo, ' ', n.nombre, ' ', n.genero, ' ', n.duracion, ' ', n.director, ' ', n.precio);
  end;
  close(a);
  close(txt);
end;

procedure imprimir(var a: archivo);
var
  n: novela;
begin
  reset(a);
  while(not eof(a)) do begin
    read(a, n);
    writeln(n.codigo, ' ', n.nombre, ' ', n.genero, ' ', n.duracion, ' ', n.director, ' ', n.precio:2:0);
  end;
  close(a);
end;

procedure menu(var a: archivo);
var
  opcion: integer;
begin
  writeln('---Ingrese una opcion---');
  writeln('1) Para agregar una novela. ');
  writeln('2) Para eliminar una novela. ');
  writeln('3) Para modificar una novela. ');
  writeln('4) Listar novelas. ');
  writeln('5) Para imprimir.');
  readln(opcion);
  while(opcion <> -1) do begin
    case(opcion) of
      1: agregarNovela(a);
      2: eliminarNovela(a);
      3: modificar(a);
      4: listar(a);
      5: imprimir(a);
    end;
    writeln('---Ingrese una opcion---');
	writeln('1) Para agregar una novela. ');
	writeln('2) Para eliminar una novela. ');
	writeln('3) Para modificar una novela. ');
	writeln('4) Listar novelas. ');
	writeln('5) Para imprimir.');
	readln(opcion);
  end;
end;

var
  a: archivo;
begin
  assign(a,'P3.ej3.dat');
  cargarArchivo(a);
  menu(a);
  imprimir(a);
end.
    
