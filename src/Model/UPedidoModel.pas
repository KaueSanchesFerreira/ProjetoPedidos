unit UPedidoModel;

interface

uses
  System.Generics.Collections,
  System.SysUtils;

type
  TProdutoPedido = class
  public
    Id: Integer;
    NumeroPedido: Integer;
    CodigoProduto: Integer;
    DescricaoProduto: string;
    Quantidade: Integer;
    ValorUnitario: Double;
    ValorTotal: Double;
  end;

  TPedido = class
  public
    Numero: Integer;
    DataEmissao: TDateTime;
    CodigoCliente: Integer;
    NomeCliente: string;
    CidadeCliente: string;
    UFCliente: string;
    ValorTotal: Double;
    Produtos: TObjectList<TProdutoPedido>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  Produtos := TObjectList<TProdutoPedido>.Create(True);
end;

destructor TPedido.Destroy;
begin
  Produtos.Free;
  inherited;
end;

end.

