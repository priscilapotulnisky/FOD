program ejercicio7;
const 
  valorAlto = 9999;
  dimF = 3; //son 10
type
  maestro = record
    codLocalidad: integer;
    nombreLocalidad: string;
    codCepa: integer;
    nombreCepa: string;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  end;
  
  detalle = record
    codLocalidad: integer;
    codCepa: integer;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  end;
  
  archivoMaestro = file of maestro;
  archivoDetalle = file of detalle;
  
  vectorArchivos = array [1..dimF] of archivoDetalle;
  vectorRegistros = array [1..dimF] of detalle;

procedure detallesQueSeDisponen(var aDetalle: archivoDetalle); //este proceso carga un archivo binario detalle (desde un txt)
var
  txt: Text;
  d: detalle;
  ruta: string;
begin
  write('Ingrese el nombre del archivo binario: ');
  readln(ruta);
  assign(aDetalle, ruta);
  write('Ingrese el nombre del archivo de texto: ');
  readln(ruta);
  assign(txt, ruta);
  rewrite(aDetalle);
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, d.codLocalidad, d.codCepa, d.cantActivos, d.cantNuevos, d.cantRecuperados, d.cantFallecidos);
    write(aDetalle, d);
  end;
  close(txt);
  close(aDetalle);
  writeln('Archivo detalle cargado');
end;

procedure cargarVector(var v: vectorArchivos);
var
  i: integer;
begin
  for i:= 1 to dimF do
    detallesQueSeDisponen(v[i]);
end;

procedure maestroQueSeDispone(var aMaestro: archivoMaestro);
var
  txt: Text;
  m: maestro;
begin
  assign(txt, 'archivoMaestroEj7.txt');
  assign(aMaestro, 'archivoMaestroEj7.dat');
  rewrite(aMaestro);
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, m.codLocalidad, m.codCepa, m.cantActivos, m.cantRecuperados, m.cantFallecidos, m.nombreLocalidad);
    readln(txt, m.nombreCepa);
    write(aMaestro, m);
  end;
  close(txt);
  close(aMaestro);
  writeln('Archivo maestro cargado');
end;

procedure leer(var aDetalle: archivoDetalle; var dato: detalle);
begin
  if(not eof(aDetalle)) then
    read(aDetalle, dato)
  else
    dato.codLocalidad:= valorAlto;
end;

procedure minimo(var v: vectorArchivos; var vRegistros: vectorRegistros; var min: detalle);
var
  i: integer;
  pos: integer;
begin
  min.codLocalidad:= valorAlto;
  for i := 1 to dimF do begin
    if (vRegistros[i].codLocalidad <= min.codLocalidad) then begin
      min := vRegistros[i];
	  pos := i;
	end;
  end;
  if(min.codLocalidad <> valorAlto)then
    leer(v[pos], vRegistros[pos]);
end; 

procedure actualizar(var aMaestro: archivoMaestro; var v: vectorArchivos);
var
  i: integer;
  vRegistros: vectorRegistros;
  m: maestro;
  min: detalle;
  codigoLocActual: integer;
  cantCasosLocalidad: integer;
  codigoCepaActual: integer;
  cant: integer;
begin
  cant:= 0;
  for i:= 1 to dimF do begin
    reset(v[i]);
    leer(v[i], vRegistros[i]);
  end;
  minimo(v, vRegistros, min);
  reset(aMaestro);
  read(aMaestro, m);
  while(min.codLocalidad <> valorAlto) do begin
    codigoLocActual:= min.codLocalidad;
    cantCasosLocalidad:= 0;
    while(min.codLocalidad = codigoLocActual) do begin
      codigoCepaActual:= min.codCepa;
      while(min.codLocalidad = codigoLocActual) and (min.codCepa = codigoCepaActual) do begin
        m.cantFallecidos:= m.cantFallecidos + min.cantFallecidos;
        m.cantRecuperados:= m.cantRecuperados + min.cantRecuperados;
        m.cantActivos:= m.cantActivos + min.cantActivos;
        m.cantNuevos:= m.cantNuevos + min.cantNuevos;
        cantCasosLocalidad:= cantCasosLocalidad + min.cantActivos;
        minimo(v, vRegistros, min);
      end;
      while(m.codLocalidad <> codigoLocActual) do
        read(aMaestro, m);
      seek(aMaestro, filepos(aMaestro) - 1);
      write(aMaestro, m);
      if(not eof(aMaestro)) then
        read(aMaestro, m);
   end;
   if(cantCasosLocalidad > 50) then
     cant:= cant + 1;
  end;
  writeln('La cantidad de localidades con mas de 50 casos activos es de: ', cant);
  close(aMaestro);
  for i:= 1 to dimF do 
    close(v[i]);
end;

procedure imprimirMaestro(var aMaestro: archivoMaestro);
var
  m: maestro;
begin
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, m);
    writeln('CodLocalidad: ', m.codLocalidad, ' CodCepa: ', m.codCepa, ' Casos activos: ', m.cantActivos, ' Casos nuevos: ', m.cantNuevos, ' Recuperados: ', m.cantRecuperados, ' Fallecidos: ', m.cantFallecidos, ' NombreLocalidad: ', m.nombreLocalidad, ' Nombre Cepa: ', m.nombreCepa);
  end;
  close(aMaestro);
end;

var
  aMaestro: archivoMaestro;
  v: vectorArchivos;
begin
  cargarVector(v);
  maestroQueSeDispone(aMaestro);
  actualizar(aMaestro, v);
  imprimirMaestro(aMaestro);
end.

