program ejercicio;
const
  valorAlto = 9999;
  dimF = 3; //son 10
type
  maestro = record
    codProvincia: integer;
    nombreProvincia: string;
    codLocalidad: integer;
    nombreLocalidad: string;
    sinLuz: integer;
    sinGas: integer;
    deChapa: integer;
    sinAgua: integer;
    sinSanitario: integer;
  end;
  
  detalle = record
    codProvincia: integer;
    codLocalidad: integer;
    conLuz: integer;
    construidas: integer;
    conAgua: integer;
    conGas: integer;
    entrega: integer;
  end;
  
  archivoMaestro = file of maestro;
  archivoDetalle = file of detalle;
  
  vectorArchivos = array[1..dimF] of archivoDetalle;
  vectorRegistros = array[1..dimF] of detalle;
  
procedure cargarMaestro(var aMaestro: archivoMaestro);
var
  m: maestro;
  txt: Text;
begin
  assign(txt, 'P2.ej14-maestro.txt');
  reset(txt);
  rewrite(aMaestro);
  while(not eof(txt)) do begin
    readln(txt, m.codProvincia, m.codLocalidad, m.sinLuz, m.sinGas, m.deChapa, m.sinAgua, m.sinSanitario, m.nombreProvincia);
    readln(txt, m.nombreLocalidad);
    write(aMaestro, m);
  end;
  close(aMaestro);
  close(txt);
end;

procedure cargaDetalle(var aDetalle: archivoDetalle);
var
  txt: Text;
  d: detalle;
  ruta: string;
  nombre: string;
begin
  write('Ingrese el nombre del archivo binario: ');
  readln(nombre);
  write('Ingrese el nombre del archivo de texto: ');
  readln(ruta);
  assign(txt, ruta);
  assign(aDetalle, nombre);
  reset(txt);
  rewrite(aDetalle);
  while(not eof(txt)) do begin
    readln(txt, d.codProvincia, d.codLocalidad, d.construidas, d.conAgua, d.conGas, d.entrega);
    write(aDetalle, d);
  end;
  close(aDetalle);
  close(txt);
end;

procedure cargarDetalles(var vArchivos: vectorArchivos; var vRegistros: vectorRegistros);
var
  i: integer;
begin
  for i:= 1 to dimF do 
    cargaDetalle(vArchivos[i]);
end;
  
procedure leer(var aDetalle: archivoDetalle; var d: detalle);
begin
  if(not eof (aDetalle)) then 
    read(aDetalle, d)
  else
    d.codProvincia:= valorAlto;
end;

procedure minimo(var vDetalles: vectorArchivos; var vRegistros: vectorRegistros; var min: detalle);
var
  i: integer;
  pos: integer;
begin
  min.codProvincia:= valorAlto;
  for i:= 1 to dimF do begin
    if(vRegistros[i].codProvincia <= min.codProvincia) then begin
      min:= vRegistros[i];
      pos:= i;
    end;
  end;
  if(min.codProvincia <> valorAlto) then 
    leer(vDetalles[pos], vRegistros[pos]);
end;

procedure actualizar(var aMaestro: archivoMaestro; var aDetalles: vectorArchivos);
var
  vRegistros: vectorRegistros;
  m: maestro;
  min: detalle;
  i: integer;
  provActual: integer;
  locActual: integer;
begin
  reset(aMaestro);
  for i:= 1 to dimF do begin
    reset(aDetalles[i]);
    leer(aDetalles[i], vRegistros[i]);
  end;
  minimo(aDetalles, vRegistros, min);
  while(min.codProvincia <> valorAlto) do begin
    read(aMaestro, m);
    while(m.codProvincia <> min.codProvincia) do 
      read(aMaestro, m);
    provActual:= min.codProvincia;
    while(provActual = min.codProvincia) do begin
      locActual:= min.codLocalidad;
      while(provActual = min.codProvincia) and (locActual = min.codLocalidad) do begin
        m.sinLuz:= m.sinLuz - min.conLuz;
        m.sinAgua:= m.sinAgua - min.conAgua;
        m.sinGas:= m.sinGas - min.conGas;
        m.sinSanitario:= m.sinSanitario - min.entrega;
        m.deChapa:= m.deChapa - min.construidas;
        minimo(aDetalles, vRegistros, min);
      end;
      seek(aMaestro, filepos(aMaestro) - 1);
      write(aMaestro, m);
    end;
  end;
  close(aMaestro);
  for i:= 1 to dimF do 
    close(aDetalles[i]);
end;

var
  aMaestro: archivoMaestro;
  vArchivos: vectorArchivos;
  vRegistros: vectorRegistros;
begin
  assign(aMaestro, 'P2.ej14-maestro.dat');
  cargarMaestro(aMaestro);
  cargarDetalles(vArchivos, vRegistros);
  actualizar(aMaestro, vArchivos);
end.
        
  
