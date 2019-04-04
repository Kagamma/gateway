unit MainUnit;

interface

uses
  Crt,
  SysUtils,
  Classes,
  BrookAction,
  strutils;

type
  TMainAction = class(TBrookAction)
  private
    procedure Gateway(Method: string);
  public
    procedure Get; override;
    procedure Post; override;
    procedure Put; override;
    procedure Delete; override;
    procedure Options; override;
  end;

implementation

uses
  fphttpclient;

procedure TMainAction.Gateway(Method: string);
var
  SS: TStringStream;
  BaseUrl: string = 'http://localhost:8090';
  Url: string;
  Client: TFPHTTPClient;
  i: integer;
  StatusCode: integer;
begin
  Client := TFPHTTPClient.Create(nil);
  SS := TStringStream.Create('');
  try
    Url := BaseUrl + TheRequest.URI;
    TextColor(7);
    System.Writeln('Send request to: ' + Url);
    for i := 0 to TheRequest.FieldCount - 1 do
    begin
      TextColor(Yellow);
      System.Writeln(' - ' + TheRequest.FieldNames[i] + ': ' + TheRequest.FieldValues[i]);
      Client.AddHeader(TheRequest.FieldNames[i], TheRequest.FieldValues[i]);
    end;
    try
      Client.HTTPMethod(Method, Url, SS, [200, 302, 304, 400, 401, 403, 404, 500]);
      StatusCode := Client.ResponseStatusCode;
    except
      on E: Exception do
      begin
        StatusCode := 500;
        TextColor(LightRed);
        System.Writeln(' * ' + E.Message);
      end;
    end;
    TheResponse.Code := StatusCode;
    TheResponse.SetCustomHeader('Access-Control-Allow-Origin', '*');
    Writeln(SS.DataString);
    TextColor(LightGreen);
    System.Writeln(' + Status: ', StatusCode);
    if SS.Size > 0 then
      System.Writeln(' + Content: ' + SS.DataString);
    TextColor(7);
    System.Writeln('Done sending request to: ' + Url);
  finally
    FreeAndNil(Client);
    FreeAndNil(SS);
  end;
end;

procedure TMainAction.Get;
begin
  Gateway('GET');
end;

procedure TMainAction.Post;
begin
  Gateway('POST');
end;

procedure TMainAction.Put;
begin
  Gateway('PUT');
end;

procedure TMainAction.Delete;
begin
  Gateway('DELETE');
end;

procedure TMainAction.Options;
begin
  Gateway('OPTIONS');
end;

initialization
  TMainAction.Register('*', true);

end.
