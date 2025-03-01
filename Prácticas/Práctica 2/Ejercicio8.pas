program ejercicio8;
const
  valorAlto = 9999;
type
  maestro = record
    codCliente: integer;
    nombre: string;
    apellido: string;
    anio: integer;
    mes: integer;
    dia: integer;
    monto: real;
  end;
  
  //tengo que informar por cliente 
  
  datos = record
    codCliente: integer;
    nomYap: string;
    anio: integer;
    mes: integer;
  end;
  
  archivoMaestro = file of maestro;
  
procedure maestroQueSeDispone(var aMaestro: archivoMaestro);
var
  txt: Text;
  m: maestro;
begin
  assign(aMaestro, 'archivoMaestroEj8.dat');
  assign(txt, 'archivoMaestroEj8.txt');
  rewrite(aMaestro);
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, m.codCliente, m.anio, m.mes, m.dia, m.monto, m.nombre);
    readln(txt, m.apellido);
    write(aMaestro, m);
  end;
  close(txt);
  close(aMaestro);
  writeln('Archivo maestro cargado');
end;

procedure leer(var aMaestro: archivoMaestro; var dato: maestro);
begin
  if(not eof(aMaestro)) then
    read(aMaestro, dato)
  else
    dato.codCliente:= valorAlto;
end;

procedure reporte(var aMaestro: archivoMaestro);
var
  d:datos;
  m: maestro;
  totalPorMes: real;
  totalAnio: real;
  totalEmpresa: real;
begin
  reset(aMaestro);
  leer(aMaestro, m);
  totalEmpresa:= 0;
  while(m.codCliente <> valorAlto) do begin
    writeln('Codigo del cliente ', m.codCliente, ' Nombre ', m.nombre, ' Apellido ', m.apellido);
    d.codCliente:= m.codCliente;
    while(m.codCliente = d.codCliente) do begin
      writeln('Anio ', m.anio);
      d.anio:= m.anio;
      totalAnio:= 0;
      while(m.codCliente = d.codCliente) and (m.anio = d.anio) do begin
        d.mes:= m.mes;
        totalPorMes:= 0;
        while(m.codCliente = d.codCliente) and (m.anio = d.anio) and (m.mes = d.mes) do begin
          totalPorMes:= totalPorMes + m.monto;
          leer(aMaestro, m);
        end;
        if(totalPorMes <> 0) then begin
          writeln('Total gastado en el mes ', d.mes, ': ', totalPorMes:0:2);
          totalAnio:= totalAnio + totalPorMes;
        end;
      end;
      writeln('Total gastado en el anio: ', totalAnio:0:2);
      totalEmpresa:= totalEmpresa + totalAnio;
    end;
  end;
  writeln('Monto total obtenido por la empresa: ', totalEmpresa:0:2);
  close(aMaestro);
end;

var
  aMaestro: archivoMaestro;
begin
  maestroQueSeDispone(aMaestro);
  reporte(aMaestro);
end.
