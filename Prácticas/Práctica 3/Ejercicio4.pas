program ejercicio4;
type
  flores = record
    nombre: string;
    codigo: integer;
  end;
  
  archivo = file of flores;

procedure cabeceraLista(var f: flores);
begin
  f.nombre:= '';
  f.codigo:= 0;
end;

procedure leer(var f: flores);
begin
  write('-Codigo: ');
  readln(f.codigo);
  if(f.codigo <> -1) then begin
    write('-Nombre: ');
    readln(f.nombre);
  end;
end;

procedure cargarArchivo(var nombreLogico: archivo);
var
  f: flores;
  nombreFisico: string;
begin
  write('Ingrese el nombre del archivo binario: ');
  readln(nombreFisico);
  assign(nombreLogico, nombreFisico);
  rewrite(nombreLogico);
  cabeceraLista(f);
  write(nombreLogico, f);
  leer(f);
  while(f.codigo <> -1) do begin
    write(nombreLogico, f);
    leer(f);
  end;
  close(nombreLogico);
end;

procedure agregarFlor(var nombreLogico: archivo; nombre: string; codigo: integer);
var
  f: flores;
  aux: flores;
  pos: integer;
begin
  reset(nombreLogico);
  read(nombreLogico, aux);
  f.nombre:= nombre;
  f.codigo:= codigo;
  if(aux.codigo < 0) then begin
    pos:= aux.codigo * -1;
    seek(nombreLogico, pos);
    read(nombreLogico, aux);
    seek(nombreLogico, filepos(nombreLogico) -1);
    write(nombreLogico, f);
    seek(nombreLogico, 0);
    write(nombreLogico, aux);
  end
  else begin
    seek(nombreLogico, filesize(nombreLogico));
    write(nombreLogico, f);
  end;
  close(nombreLogico);
end;

procedure listar(var nombreLogico: archivo);
var
  f:flores;
begin
  reset(nombreLogico);
  while(not eof(nombreLogico)) do begin
    read(nombreLogico, f);
    if(f.codigo >= 0) then
      writeln('Nombre: ', f.nombre, ' Codigo: ', f.codigo);
  end;
  close(nombreLogico);
end;

procedure menu(var nombreLogico: archivo);
var
  opcion: integer;
  nombre: string;
  codigo: integer;
begin
  writeln('====== MENU ======');
  writeln('1: Para cargar el archivo.');
  writeln('2: Para agregar una flor.');
  writeln('3: Para listar las flores.');
  writeln('4: Para salir del programa. ');
  readln(opcion);
  while(opcion <> 4) do begin
    case(opcion) of 
      1: cargarArchivo(nombreLogico);
      2: begin 
         write('Ingrese el nombre de la flor: ');
         readln(nombre);
         write('Codigo de la flor: ');
         readln(codigo);
         agregarFlor(nombreLogico, nombre, codigo);
         end;    
      3: listar(nombreLogico); 
    end;
    writeln('====== MENU ======');
    writeln('1: Para cargar el archivo.');
    writeln('2: Para agregar una flor.');
    writeln('3: Para listar las flores.');
    writeln('4: Para salir del programa. ');
    readln(opcion);
  end;
end;

var
  nombreLogico: archivo;
begin
  menu(nombreLogico);
end.
