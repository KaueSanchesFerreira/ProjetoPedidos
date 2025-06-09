unit UPedidoDAO;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  UPedidoModel,
  UConexaoDB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Datasnap.DBClient,
  DB;

type
  TPedidoDAO = class
  private
    FConexao: TFDConnection;
    function ObterProximoNumeroPedido: Integer;
    function ItemExiste(Id: Integer): Boolean;
  public
    constructor Create;
    function GravarOuAlterarPedido(Pedido: TPedido): Boolean;
    function PesquisarPedido(Numero: Integer): TPedido;
    class function CancelarPedido(NumeroPedido: Integer): Boolean;
    class function ListarPedidos: TClientDataSet;
  end;

implementation

uses
  Dialogs;

constructor TPedidoDAO.Create;
begin
  FConexao := TConexaoDB.Create.GetConnection;
end;

function TPedidoDAO.ObterProximoNumeroPedido: Integer;
var
  Qry: TFDQuery;
begin
  Result := 1;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConexao;
    Qry.SQL.Text := 'SELECT COALESCE(MAX(numero_pedido), 0) + 1 AS proximo FROM pedidos';
    Qry.Open;
    Result := Qry.FieldByName('proximo').AsInteger;
  finally
    Qry.Free;
  end;
end;

function TPedidoDAO.ItemExiste(Id: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConexao;
    Qry.SQL.Text := 'SELECT id FROM pedidos_produtos WHERE id = :id';
    Qry.ParamByName('id').AsInteger := Id;
    Qry.Open;
    Result := not Qry.IsEmpty;
  finally
    Qry.Free;
  end;
end;

function TPedidoDAO.GravarOuAlterarPedido(Pedido: TPedido): Boolean;
var
  Qry: TFDQuery;
  Produto: TProdutoPedido;
  ListaIdItensTela: TList<Integer>;
  IdsParaExcluir: string;
  Idx: Integer;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  ListaIdItensTela := TList<Integer>.Create;
  try
    Qry.Connection := FConexao;
    FConexao.StartTransaction;
    try
      if Pedido.Numero = 0 then
        Pedido.Numero := ObterProximoNumeroPedido;

      Qry.SQL.Text := 'SELECT numero_pedido FROM pedidos WHERE numero_pedido = :numero';
      Qry.ParamByName('numero').AsInteger := Pedido.Numero;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        Qry.SQL.Text :=
          'INSERT INTO pedidos (numero_pedido, data_emissao, codigo_cliente, valor_total) ' +
          'VALUES (:numero, :data, :cliente, :total)';
      end
      else
      begin
        Qry.SQL.Text :=
          'UPDATE pedidos SET data_emissao = :data, codigo_cliente = :cliente, valor_total = :total ' +
          'WHERE numero_pedido = :numero';
      end;
      Qry.ParamByName('numero').AsInteger := Pedido.Numero;
      Qry.ParamByName('data').AsDate := Pedido.DataEmissao;
      Qry.ParamByName('cliente').AsInteger := Pedido.CodigoCliente;
      Qry.ParamByName('total').AsFloat := Pedido.ValorTotal;
      Qry.ExecSQL;

      for Produto in Pedido.Produtos do
      begin
        if Produto.Id > 0 then
          ListaIdItensTela.Add(Produto.Id);

        if (Produto.Id > 0) and ItemExiste(Produto.Id) then
        begin
          Qry.SQL.Text :=
            'UPDATE pedidos_produtos SET codigo_produto = :cod, quantidade = :qtd, valor_unitario = :unit, valor_total = :total ' +
            'WHERE id = :id';
          Qry.ParamByName('id').AsInteger := Produto.Id;
        end
        else
        begin
          Qry.SQL.Text :=
            'INSERT INTO pedidos_produtos (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
            'VALUES (:pedido, :cod, :qtd, :unit, :total)';
          Qry.ParamByName('pedido').AsInteger := Pedido.Numero;
        end;

        Qry.ParamByName('cod').AsInteger := Produto.CodigoProduto;
        Qry.ParamByName('qtd').AsInteger := Produto.Quantidade;
        Qry.ParamByName('unit').AsFloat := Produto.ValorUnitario;
        Qry.ParamByName('total').AsFloat := Produto.ValorTotal;
        Qry.ExecSQL;
      end;

      FConexao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConexao.Rollback;
        ShowMessage('Erro ao gravar ou alterar pedido: ' + E.Message);
      end;
    end;
  finally
    Qry.Free;
    ListaIdItensTela.Free;
  end;
end;

function TPedidoDAO.PesquisarPedido(Numero: Integer): TPedido;
var
  Qry: TFDQuery;
  Pedido: TPedido;
  Produto: TProdutoPedido;
begin
  Result := nil;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConexao;

    Qry.SQL.Text := 'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total FROM pedidos WHERE numero_pedido = :numero';
    Qry.ParamByName('numero').AsInteger := Numero;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      Pedido := TPedido.Create;
      Pedido.Numero := Qry.FieldByName('numero_pedido').AsInteger;
      Pedido.DataEmissao := Qry.FieldByName('data_emissao').AsDateTime;
      Pedido.CodigoCliente := Qry.FieldByName('codigo_cliente').AsInteger;
      Pedido.ValorTotal := Qry.FieldByName('valor_total').AsFloat;

      Qry.Close;
      Qry.SQL.Text :=
        'SELECT pp.id, pp.numero_pedido, pp.codigo_produto, p.descricao, pp.quantidade, pp.valor_unitario, pp.valor_total ' +
        'FROM pedidos_produtos pp INNER JOIN produtos p ON p.codigo = pp.codigo_produto ' +
        'WHERE pp.numero_pedido = :numero';
      Qry.ParamByName('numero').AsInteger := Numero;
      Qry.Open;
      while not Qry.Eof do
      begin
        Produto := TProdutoPedido.Create;
        Produto.Id := Qry.FieldByName('id').AsInteger;
        Produto.NumeroPedido := Qry.FieldByName('numero_pedido').AsInteger;
        Produto.CodigoProduto := Qry.FieldByName('codigo_produto').AsInteger;
        Produto.DescricaoProduto := Qry.FieldByName('descricao').AsString;
        Produto.Quantidade := Qry.FieldByName('quantidade').AsInteger;
        Produto.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
        Produto.ValorTotal := Qry.FieldByName('valor_total').AsFloat;
        Pedido.Produtos.Add(Produto);
        Qry.Next;
      end;

      Result := Pedido;
    end;
  finally
    Qry.Free;
  end;
end;

class function TPedidoDAO.CancelarPedido(NumeroPedido: Integer): Boolean;
var
  Qry: TFDQuery;
  Conn: TFDConnection;
begin
  Result := False;
  Conn := TConexaoDB.GetConnection;
  Qry := TFDQuery.Create(nil);
  try
    Conn.StartTransaction;
    try
      Qry.Connection := Conn;
      Qry.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numero';
      Qry.ParamByName('numero').AsInteger := NumeroPedido;
      Qry.ExecSQL;

      Qry.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :numero';
      Qry.ParamByName('numero').AsInteger := NumeroPedido;
      Qry.ExecSQL;

      Conn.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Conn.Rollback;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

class function TPedidoDAO.ListarPedidos: TClientDataSet;
var
  CDS: TClientDataSet;
  Qry: TFDQuery;
begin
  CDS := TClientDataSet.Create(nil);
  CDS.FieldDefs.Add('Numero_pedido', ftInteger);
  CDS.FieldDefs.Add('Data_emissao', ftDate);
  CDS.FieldDefs.Add('Codigo_cliente', ftInteger);
  CDS.FieldDefs.Add('Valor_total', ftString, 20);
  CDS.CreateDataSet;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := TConexaoDB.GetConnection;
    Qry.SQL.Text := 'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total FROM pedidos ORDER BY numero_pedido DESC';
    Qry.Open;
    while not Qry.Eof do
    begin
      CDS.Append;
      CDS.FieldByName('numero_pedido').AsInteger := Qry.FieldByName('numero_pedido').AsInteger;
      CDS.FieldByName('data_emissao').AsDateTime := Qry.FieldByName('data_emissao').AsDateTime;
      CDS.FieldByName('codigo_cliente').AsInteger := Qry.FieldByName('codigo_cliente').AsInteger;
      CDS.FieldByName('valor_total').AsString :=  FormatFloat('#,###,###,##0.00',Qry.FieldByName('valor_total').AsFloat);
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

