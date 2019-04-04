unit Brokers;

{$mode objfpc}{$H+}

interface

uses
  BrookFCLHttpAppBroker, BrookUtils, BrookApplication;

implementation

initialization
  BrookSettings.Port := 4444;
  BrookSettings.AllowOrigin := '*';
  TBrookHTTPApplication(BrookApp.Instance).Threaded := true;

end.
