unit MainUnit;

interface

uses
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
  Req, Res: TStringStream;
  BaseUrl: string = 'http://192.168.103.153:8090';
  Url, Name, Value: string;
  Client: TFPHTTPClient;
  i: integer;
  StatusCode: integer;
begin
  Client := TFPHTTPClient.Create(nil);
  Res := TStringStream.Create('');
  Req := TStringStream.Create('');
  try
    Url := BaseUrl + TheRequest.URI;
    System.Writeln;
    System.Writeln('---------------------------------');
    System.Writeln;
    System.Writeln(Method + ': ' + Url);
    for i := 0 to TheRequest.FieldCount - 1 do
    begin
      Name := TheRequest.FieldNames[i];
      Value := TheRequest.FieldValues[i];
      if (Name = 'Authorization') or (Name = 'X-API-KEY') then
      begin
        System.Writeln(' - ' + Name + ': ' + Value);
        Client.AddHeader(Name, Value);
      end;
    end;
    if Method <> 'OPTIONS' then
    begin
      try
        if TheRequest.Content <> '' then
          System.Writeln(' - Content: ' + TheRequest.Content);
        Req.WriteString(TheRequest.Content);
        Client.RequestBody := Req;
        Client.HTTPMethod(Method, Url, Res, [200, 302, 304, 400, 401, 403, 404, 500]);
        StatusCode := Client.ResponseStatusCode;
      except
        on E: Exception do
        begin
          StatusCode := 500;
          System.Writeln(' * ' + E.Message);
        end;
      end;
    end
    else
      StatusCode := 200;
    TheResponse.Code := StatusCode;
    TheResponse.SetCustomHeader('Access-Control-Allow-Origin', '*');
    TheResponse.SetCustomHeader('Access-Control-Allow-Headers', 'content-type,authorization,x-api-key');
    TheResponse.SetCustomHeader('Access-Control-Allow-Credentials','true');
    TheResponse.SetCustomHeader('Access-Control-Allow-Methods','GET,POST,PUT,DELETE');
    TheResponse.Content := Res.DataString;
    System.Writeln(' + Status: ', StatusCode);
    if Res.Size > 0 then
      System.Writeln(' + Content: ' + TheResponse.Content);
  finally
    FreeAndNil(Client);
    FreeAndNil(Res);
    FreeAndNil(Req);
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
