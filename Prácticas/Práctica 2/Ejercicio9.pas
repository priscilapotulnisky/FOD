program ejercicio9;
const
  valorAlto = 9999;
type
  mesa = record
    codProvincia: integer;
    codLocalidad: integer;
    numero: integer;
    cantVotos: integer;
  end;
  
  archivo = file of mesa;

procedure cargarArchivo(var a: archivo);
var
  txt: Text;
  m: mesa;
begin
  assign(txt, 'P2.ej9.txt');
  reset(txt);
  rewrite(a);
  while(not eof(txt)) do begin
    readln(txt, m.codProvincia, m.codLocalidad, m.numero, m.cantVotos);
    write(a, m);
  end;
  close(a);
  close(txt);
end;

procedure leer(var a: archivo; var m: mesa);
begin
  if(not eof(a)) then
    read(a, m)
  else
    m.codProvincia:= valorAlto;
end;

procedure listar(var a: archivo);
var
  m: mesa;
  provActual: integer;
  locActual: integer;
  totalLoc: integer;
  totalProv: integer;
  totalGeneral: integer;
begin
  reset(a);
  totalGeneral:= 0;
  leer(a, m);
  while(m.codProvincia <> valorAlto) do begin
    writeln('Codigo de provincia: ', m.codProvincia);
    provActual:= m.codProvincia;
    totalProv:= 0;
    while(provActual = m.codProvincia) do begin
       writeln('Codigo de localidad: ', m.codLocalidad);
       locActual:= m.codLocalidad;
       totalLoc:= 0;
       while(provActual = m.codProvincia) and (locActual = m.codLocalidad) do begin
         totalLoc:= totalLoc + m.cantVotos;
         leer(a, m);
       end;
       writeln('Total de votos: ', totalLoc);
       totalProv:= totalProv + totalLoc;
    end;
    writeln('Total de votos provincia: ', totalProv);
    totalGeneral:= totalGeneral + totalProv;
  end;
  writeln('Total general de votos: ', totalGeneral);
  close(a);
end;

var
  a: archivo;
begin
  assign(a, 'P2.ej9.dat');
  cargarArchivo(a);
  listar(a);
end.
   
