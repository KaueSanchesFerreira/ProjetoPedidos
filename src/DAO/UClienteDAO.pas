unit UClienteDAO;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  UClienteModel,
  Datasnap.DBClient,
  System.SysUtils,
  System.Classes,
  DB;

type
  TClienteDAO = class
  public
    class function BuscarPorCodigo(const ACodigo: Integer; FDConnection: TFDConnection): TCliente;
    class function ListarClientes(FDConnection: TFDConnection): TClientDataSet;
  end;

implementation

class function TClienteDAO.BuscarPorCodigo(const ACodigo: Integer; FDConnection: TFDConnection): TCliente;
var
  Qry: TFDQuery;
begin
  Result := nil;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FDConnection;
    Qry.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :codigo';
    Qry.ParamByName('codigo').AsInteger := ACodigo;
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      Result := TCliente.Create;
      Result.Codigo := Qry.FieldByName('codigo').AsInteger;
      Result.Nome := Qry.FieldByName('nome').AsString;
      Result.Cidade := Qry.FieldByName('cidade').AsString;
      Result.UF := Qry.FieldByName('uf').AsString;
    end;
  finally
    Qry.Free;
  end;
end;

class function TClienteDAO.ListarClientes(FDConnection: TFDConnection): TClientDataSet;
var
  CDS: TClientDataSet;
  Qry: TFDQuery;
begin
  CDS := TClientDataSet.Create(nil);
  CDS.FieldDefs.Add('Codigo', ftInteger);
  CDS.FieldDefs.Add('Nome', ftString, 30);
  CDS.FieldDefs.Add('Cidade', ftString, 30);
  CDS.FieldDefs.Add('UF', ftString, 10);
  CDS.CreateDataSet;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FDConnection;
    Qry.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes ORDER BY nome';
    Qry.Open;
    while not Qry.Eof do
    begin
      CDS.Append;
      CDS.FieldByName('codigo').AsInteger := Qry.FieldByName('codigo').AsInteger;
      CDS.FieldByName('nome').AsString := Qry.FieldByName('nome').AsString;
      CDS.FieldByName('cidade').AsString := Qry.FieldByName('cidade').AsString;
      CDS.FieldByName('uf').AsString := Qry.FieldByName('uf').AsString;
      CDS.Post;
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
  CDS.First;
  Result := CDS;
end;

end.

