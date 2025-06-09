unit UProdutoDAO;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  UProdutoModel,
  Datasnap.DBClient,
  System.SysUtils,
  System.Classes,
  DB;

type
  TProdutoDAO = class
  public
    class function BuscarPorCodigo(const ACodigo: Integer; FDConnection: TFDConnection): TProduto;
    class function ListarProdutos(FDConnection: TFDConnection): TClientDataSet;
  end;

implementation

class function TProdutoDAO.BuscarPorCodigo(const ACodigo: Integer; FDConnection: TFDConnection): TProduto;
var
  Qry: TFDQuery;
begin
  Result := nil;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FDConnection;
    Qry.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :codigo';
    Qry.ParamByName('codigo').AsInteger := ACodigo;
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      Result := TProduto.Create;
      Result.Codigo := Qry.FieldByName('codigo').AsInteger;
      Result.Descricao := Qry.FieldByName('descricao').AsString;
      Result.PrecoVenda := Qry.FieldByName('preco_venda').AsFloat;
    end;
  finally
    Qry.Free;
  end;
end;

class function TProdutoDAO.ListarProdutos(FDConnection: TFDConnection): TClientDataSet;
var
  CDS: TClientDataSet;
  Qry: TFDQuery;
begin
  CDS := TClientDataSet.Create(nil);
  CDS.FieldDefs.Add('Codigo', ftInteger);
  CDS.FieldDefs.Add('Descricao', ftString, 30);
  CDS.FieldDefs.Add('Preco_venda', ftString, 20);
  CDS.CreateDataSet;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FDConnection;
    Qry.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos ORDER BY descricao';
    Qry.Open;
    while not Qry.Eof do
    begin
      CDS.Append;
      CDS.FieldByName('codigo').AsInteger := Qry.FieldByName('codigo').AsInteger;
      CDS.FieldByName('descricao').AsString := Qry.FieldByName('descricao').AsString;
      CDS.FieldByName('preco_venda').AsString := FormatFloat('#,###,###,##0.00',  Qry.FieldByName('preco_venda').AsFloat);
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

