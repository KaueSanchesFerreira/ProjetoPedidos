program ProjetoPedidos;

uses
  Vcl.Forms,
  UFrmPedido in 'src\Forms\UFrmPedido.pas' {FrmPedido},
  UPedidoModel in 'src\Model\UPedidoModel.pas',
  UClienteModel in 'src\Model\UClienteModel.pas',
  UProdutoModel in 'src\Model\UProdutoModel.pas',
  UClienteDAO in 'src\DAO\UClienteDAO.pas',
  UProdutoDAO in 'src\DAO\UProdutoDAO.pas',
  UPedidoDAO in 'src\DAO\UPedidoDAO.pas',
  UConexaoDB in 'src\DAO\UConexaoDB.pas',
  UFrmPesquisaGenerica in 'src\Forms\UFrmPesquisaGenerica.pas' {FrmPesquisaGenerica};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPedido, FrmPedido);
  Application.CreateForm(TFrmPesquisaGenerica, FrmPesquisaGenerica);
  Application.Run;
end.
