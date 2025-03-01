program ejercicio10;
const
  valorAlto = 9999;
type
  maestro = record
    departamento: integer;
    division: integer;
    numEmpleado: integer;
    categoria: integer;
    cantExtras: integer;
  end;
  
  categorias = record
    categoria: integer;
    monto: real;
  end;
  
  archivoMaestro = file of maestro;
  
  vector = array [1..15] of real;
  
procedure maestroQueSeDispone(var aMaestro: archivoMaestro);
var
  txt: text;
  m: maestro;
begin
  assign(aMaestro, 'archivoMaestroEj10.dat');
  assign(txt, 'archivoMaestroEj10.txt');
  rewrite(aMaestro);
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, m.departamento, m.division, m.numEmpleado, m.categoria, m.cantExtras);
    write(aMaestro, m);
  end;
  close(txt);
  close(aMaestro);
  writeln('Archivo maestro cargado');
end;

procedure cargarVector(var v: vector);
var
  txt: text;
  c: categorias;
begin
  assign(txt, 'archivoCategoriasEj10.txt');
  reset(txt);
  while(not eof(txt)) do begin
    readln(txt, c.categoria, c.monto);
    v[c.categoria]:= c.monto;
  end;
  close(txt);
  writeln('Vector cargado');
end;

procedure leer(var aMaestro: archivoMaestro; var dato: maestro);
begin
  if(not eof(aMaestro)) then 
    read(aMaestro, dato)
  else
    dato.departamento:= valorAlto;
end;

procedure reporte(var aMaestro: archivoMaestro; v: vector);
var
  m: maestro;
  deptoActual: integer;
  divActual: integer;
  empleadoActual: integer;
  totalHoras: integer;
  totalHorasDiv: integer;
  totalHorasDep: integer;
  montoTotal: real;
  montoTotalDiv: real;
  montoTotalDep: real;
begin
  reset(aMaestro);
  leer(aMaestro, m);
  while(m.departamento <> valorAlto) do begin
    writeln('Departamento ', m.departamento);
    totalHorasDep:= 0;
    montoTotalDep:= 0;
    deptoActual:= m.departamento;
    while(m.departamento = deptoActual) do begin
      writeln('Division ', m.division);
      totalHorasDiv:= 0;
      montoTotalDiv:= 0;
      divActual:= m.division;
      while(m.departamento = deptoActual) and (m.division = divActual) do begin
        totalHoras:= 0;
        montoTotal:= 0;
        empleadoActual:= m.numEmpleado;
        while(m.departamento = deptoActual) and (m.division = divActual) and (m.numEmpleado = empleadoActual) do begin
          totalHoras:= totalHoras + m.cantExtras;
          leer(aMaestro, m);
        end;
        montoTotal:= montoTotal + (v[m.categoria] * totalHoras);
        writeln('Numero de empleado ', m.numEmpleado, ' Total de horas ', totalHoras, ' Total a cobrar ', montoTotal:0:2);
        totalHorasDiv:= totalHorasDiv + totalHoras;
        montoTotalDiv:= montoTotalDiv + montoTotal;
      end;
      writeln('Total horas por division ', totalHorasDiv, ' Monto total por division ', montoTotalDiv:0:2);
      totalHorasDep:= totalHorasDep + totalHorasDiv;
      montoTotalDep:= montoTotalDep + montoTotalDiv;
    end;
    writeln('Total horas por departamento: ', totalHorasDep, ' Monto total por departamento ', montoTotalDep:0:2);
  end;
  close(aMaestro);
end;

procedure imprimirVector(v:vector);
var
  i: integeR;
begin
  for i:= 1 to 15 do 
    write(v[i]:0:2 , ' ' );
end;

procedure imprimirMaestro(var aMaestro: archivoMaestro);
var
  m: maestro;
begin
  reset(aMaestro);
  while(not eof(aMaestro)) do begin
    read(aMaestro, m);
    writeln(m.departamento, ' ', m.division, ' ', m.numEmpleado, ' ', m.categoria, ' ' , m.cantExtras);
  end;
  close(aMaestro);
end;

var
  v: vector;
  aMaestro: archivoMaestro;
begin
  cargarVector(v);
  imprimirVector(v); //para verificar
  maestroQueSeDispone(aMaestro);
  reporte(aMaestro, v);
  imprimirMaestro(aMaestro); //para verificar
end.

