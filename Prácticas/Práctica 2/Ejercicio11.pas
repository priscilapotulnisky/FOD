program ejercicio11;
const
  valorAlto = 9999;
type
  servidor = record
    anio: integer;
    mes: integer;
    dia: integer;
    idUsuario: integer;
    tiempo: real;
  end;
  
  archivo = file of servidor;

procedure cargarArchivo(var a: archivo);
var
  s: servidor;
  txt: Text;
begin
  assign(txt, 'P2.ej11.txt');
  reset(txt);
  rewrite(a);
  while(not eof(txt)) do begin
    readln(txt, s.anio, s.mes, s.dia, s.idUsuario, s.tiempo);
    write(a, s);
  end;
  close(a);
  close(txt);
end;

procedure leer(var a: archivo; var s: servidor);
begin
  if(not eof(a)) then
    read(a, s)
  else
    s.anio:= valorAlto;
end;

procedure reporte(var a: archivo);
var
  s: servidor;
  anioActual: integer;
  mesActual: integer;
  diaActual: integer;
  usuarioActual: integer;
  totalUsuario: real;
  totalDia: real;
  totalMes: real;
  totalAnio: real;
begin
  reset(a);
  leer(a,s);
  while(s.anio <> valorAlto) do begin
    anioActual:= s.anio;
    totalAnio:= 0;
    writeln('Anio: ', anioActual);
    while(s.anio = anioActual) do begin
      mesActual:= s.mes;
      totalMes:= 0;
      writeln('Mes: ', mesActual);
      while(s.anio = anioActual) and (s.mes = mesActual) do begin
        diaActual:= s.dia;
        totalDia:= 0;
        writeln('Dia: ', diaActual);
        while(s.anio = anioActual) and (s.mes = mesActual) and (s.dia = diaActual) do begin
          usuarioActual:= s.idUsuario;
          totalUsuario:= 0;
          write('Usuario: ', usuarioActual);
          while(s.anio = anioActual) and (s.mes = mesActual) and (s.dia = diaActual) and (s.idUsuario = usuarioActual) do begin
             totalUsuario:= totalUsuario + s.tiempo;
             leer(a, s);
          end;
          totalDia:= totalDia + totalUsuario;
          writeln(' Tiempo total de acceso den el dia ', diaActual, ' mes ', mesActual, '---', totalUsuario:2:0);
        end;
        totalMes:= totalMes + totalDia;
        writeln('Tiempo total de accrso dia ', diaActual, ' mes ', mesActual, '..........', totalDia:2:0);
      end;
      totalAnio:= totalAnio + totalMes;
      writeln( 'Total tiempo de acceso mes: ', mesActual, '#####' , totalMes:2:0);
    end;
    writeln('Total tiempo de aceeso anio: ', totalAnio:2:0);
  end;
  close(a);
end;

var
  a: archivo;
begin
  assign(a, 'P2.ej11.dat');
  cargarArchivo(a);
  reporte(a);
end.
  

