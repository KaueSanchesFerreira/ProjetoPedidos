unit UConexaoDB;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  System.IniFiles,
  System.SysUtils,
  System.IOUtils;

type
  TConexaoDB = class
  private
    class var
      FConnection: TFDConnection;
    class procedure CarregarConfiguracoes(Conn: TFDConnection);
  public
    constructor Create;
    class function GetConnection: TFDConnection;
    class function TestarConexao: Boolean;
  end;

implementation

{ TConexaoDB }

constructor TConexaoDB.Create;
begin
  // Só para permitir instanciação, não faz nada
end;

class function TConexaoDB.GetConnection: TFDConnection;
begin
  if not Assigned(FConnection) then
  begin
    FConnection := TFDConnection.Create(nil);
    CarregarConfiguracoes(FConnection);
  end;
  Result := FConnection;
end;

class procedure TConexaoDB.CarregarConfiguracoes(Conn: TFDConnection);
var
  Ini: TIniFile;
  ArquivoIni: string;
  Database, Username, Password, Server, Port, DriverDLL: string;
begin
  ArquivoIni := TPath.GetFullPath(TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), '..\..\config\config.ini'));

  if not FileExists(ArquivoIni) then
    raise Exception.Create('Arquivo de configuração config.ini não encontrado em: ' + ArquivoIni);

  Ini := TIniFile.Create(ArquivoIni);
  try
    Database := Ini.ReadString('Conexao', 'Database', '');
    Username := Ini.ReadString('Conexao', 'Username', '');
    Password := Ini.ReadString('Conexao', 'Password', '');
    Server := Ini.ReadString('Conexao', 'Server', '');
    Port := Ini.ReadString('Conexao', 'Port', '3306');
    DriverDLL := Ini.ReadString('Conexao', 'DriverDLL', '');

    Conn.Connected := False;
    Conn.Params.Clear;
    Conn.Params.DriverID := 'MySQL';
    Conn.Params.Database := Database;
    Conn.Params.UserName := Username;
    Conn.Params.Password := Password;
    Conn.Params.Add('Server=' + Server);
    Conn.Params.Add('Port=' + Port);
    Conn.Params.Add('CharacterSet=utf8mb4');

    if Trim(DriverDLL) <> '' then
      Conn.Params.Add('VendorLib=' + DriverDLL);

    Conn.LoginPrompt := False;
  finally
    Ini.Free;
  end;
end;

class function TConexaoDB.TestarConexao: Boolean;
var
  Conn: TFDConnection;
begin
  Result := False;
  Conn := TFDConnection.Create(nil);
  try
    CarregarConfiguracoes(Conn);
    try
      Conn.Connected := True;
      Result := Conn.Connected;
    finally
      Conn.Connected := False;
    end;
  finally
    Conn.Free;
  end;
end;

end.

