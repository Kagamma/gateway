program gateway;

uses
{$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
{$ENDIF}{$ENDIF}
  BrookApplication, Brokers, MainUnit;

begin
  Writeln('Listening on port 4444 ...');
  BrookApp.Run;
end.