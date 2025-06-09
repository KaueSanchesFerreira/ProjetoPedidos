unit UFrmPedido;

interface

uses
  winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.Buttons,
  System.ImageList,
  Vcl.ImgList,
  Vcl.WinXPickers,
  Vcl.ComCtrls,
  Data.DB,
  Vcl.Grids,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  Datasnap.DBClient,
  ShellAPI,
  Vcl.Menus,
  Vcl.DBGrids;

type
  TFrmPedido = class(TForm)
    pnPrincipal: TPanel;
    pnTotal: TPanel;
    ImageList1: TImageList;
    gbProdutos: TGroupBox;
    lblProdutoCodigo: TLabel;
    lblProdutoDescricao: TLabel;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    lblValorTotal: TLabel;
    edtProdutoCodigo: TEdit;
    stProdutoDescricao: TStaticText;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    stValorTotal: TStaticText;
    pnTopo: TPanel;
    gbDadosPedidos: TGroupBox;
    gbClientes: TGroupBox;
    lblClienteCodigo: TLabel;
    lblClienteNome: TLabel;
    lblClienteCidade: TLabel;
    lblClienteUF: TLabel;
    edtClienteCodigo: TEdit;
    stClienteNome: TStaticText;
    stClienteCidade: TStaticText;
    stClienteUF: TStaticText;
    lblPedidoNumero: TLabel;
    edtPedidoNumero: TEdit;
    lblPedidoDataEmissao: TLabel;
    stPedidoDataEmissao: TStaticText;
    btnPesquisar: TSpeedButton;
    btnGravar: TSpeedButton;
    btnCancelar: TSpeedButton;
    dbgProdutos: TDBGrid;
    pmGrid: TPopupMenu;
    btnAlterar: TMenuItem;
    btnApagar: TMenuItem;
    lblPedidoTotal: TLabel;
    btnConfirmar: TSpeedButton;
    stPedidoTotal: TStaticText;
    mtProdutos: TFDMemTable;
    dsProdutos: TDataSource;
    mtProdutosid: TIntegerField;
    mtProdutosnumero_pedido: TIntegerField;
    mtProdutoscodigo_produto: TIntegerField;
    mtProdutosquantidade: TIntegerField;
    mtProdutosvalor_unitario: TFloatField;
    mtProdutosvalor_total: TFloatField;
    mtProdutosdescricao_produto: TStringField;
    btnPesquisarProduto: TSpeedButton;
    btnPesquisarCliente: TSpeedButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    btnPDF: TSpeedButton;
    procedure dbgProdutosTitleClick(Column: TColumn);
    procedure dbgProdutosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPedidoNumeroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnPesquisarProdutoClick(Sender: TObject);
    procedure edtProdutoCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtPedidoNumeroExit(Sender: TObject);
    procedure edtProdutoCodigoExit(Sender: TObject);
    procedure edtValorUnitarioChange(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edtClienteCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtClienteCodigoExit(Sender: TObject);
    procedure btnPesquisarClienteClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtClienteCodigoChange(Sender: TObject);
    procedure dbgProdutosDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPDFClick(Sender: TObject);
  private
    { Private declarations }
    ProdutoEditandoID: Integer;

    procedure setProdutoEditando(valor: Integer);
    procedure BuscarClientePorCodigo(Codigo: Integer);
    procedure ExportarPedidoParaHTML;
    property ProdutoEditando: Integer read ProdutoEditandoID write setProdutoEditando;

    procedure LimpaCamposProdutos;
    procedure LimpaCamposCliente;

    procedure LimpaCampos;
    procedure PesquisarPedido(Numero: Integer);
    procedure AtualizaTotalPedido;
    procedure BuscarProdutoPorCodigo(Codigo: Integer);
    procedure CalcularTotalProduto;
  public
    { Public declarations }
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.dfm}

uses
  UPedidoDAO,
  UPedidoModel,
  UClienteDAO,
  UClienteModel,
  UProdutoModel,
  UProdutoDAO,
  UConexaoDB,
  UFrmPesquisaGenerica;

procedure TFrmPedido.btnAlterarClick(Sender: TObject);
begin
  if not mtProdutos.IsEmpty then
  begin
    edtProdutoCodigo.Text := mtProdutoscodigo_produto.AsString;
    stProdutoDescricao.Caption := mtProdutosdescricao_produto.AsString;
    edtQuantidade.Text := mtProdutosquantidade.AsString;
    edtValorUnitario.Text := FormatFloat('0.00', mtProdutosvalor_unitario.AsFloat);
    stValorTotal.Caption := FormatFloat('0.00', mtProdutosvalor_total.AsFloat);

    ProdutoEditando := mtProdutos.RecNo;

    edtQuantidade.SetFocus;
  end;
end;

procedure TFrmPedido.btnApagarClick(Sender: TObject);
begin
  if not mtProdutos.IsEmpty then
  begin
    if Application.MessageBox('Deseja realmente remover este item?', 'Confirmação', MB_YESNO + MB_ICONQUESTION) = IDYES then
    begin
      mtProdutos.Delete;
      LimpaCamposProdutos;
      AtualizaTotalPedido;
    end;
  end;
end;

procedure TFrmPedido.btnCancelarClick(Sender: TObject);
var
  Numero: Integer;
begin
  if Trim(edtPedidoNumero.Text) = '' then
  begin
    Application.MessageBox('Nenhum pedido selecionado!', 'Aviso', MB_ICONWARNING + MB_OK);
    Exit;
  end;

  Numero := StrToIntDef(edtPedidoNumero.Text, 0);
  if Numero = 0 then
    Exit;

  if Application.MessageBox('Deseja realmente excluir este pedido?', 'Confirmação', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    if TPedidoDAO.CancelarPedido(Numero) then
    begin
      Application.MessageBox('Pedido excluído com sucesso!', 'Sucesso', MB_ICONINFORMATION + MB_OK);
      LimpaCampos;
    end
    else
    begin
      Application.MessageBox(PChar('Erro ao excluir pedido'), 'Erro', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TFrmPedido.btnConfirmarClick(Sender: TObject);
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario, ValorTotal: Double;
begin
  if Trim(edtProdutoCodigo.Text) = '' then
  begin
    Application.MessageBox('Informe o código do produto.', 'Aviso', MB_ICONWARNING + MB_OK);
    edtProdutoCodigo.SetFocus;
    Exit;
  end;

  if Trim(edtQuantidade.Text) = '' then
  begin
    Application.MessageBox('Informe a quantidade.', 'Aviso', MB_ICONWARNING + MB_OK);
    edtQuantidade.SetFocus;
    Exit;
  end;

  if Trim(edtValorUnitario.Text) = '' then
  begin
    Application.MessageBox('Informe o valor unitário.', 'Aviso', MB_ICONWARNING + MB_OK);
    edtValorUnitario.SetFocus;
    Exit;
  end;

  try
    CodigoProduto := StrToInt(edtProdutoCodigo.Text);
    Quantidade := StrToInt(edtQuantidade.Text);
    ValorUnitario := StrToFloat(edtValorUnitario.Text);
    ValorTotal := Quantidade * ValorUnitario;

    if Quantidade <= 0 then
    begin
      Application.MessageBox('A quantidade deve ser maior que zero.', 'Aviso', MB_ICONWARNING + MB_OK);
      edtQuantidade.SetFocus;
      Exit;
    end;

    if ValorUnitario <= 0 then
    begin
      Application.MessageBox('O valor unitário deve ser maior que zero.', 'Aviso', MB_ICONWARNING + MB_OK);
      edtValorUnitario.SetFocus;
      Exit;
    end;

    if ValorTotal <= 0 then
    begin
      Application.MessageBox('O valor total calculado é inválido.', 'Aviso', MB_ICONWARNING + MB_OK);
      Exit;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao converter valores: ' + E.Message), 'Erro', MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;

  try
    if ProdutoEditandoID > 0 then
    begin
      mtProdutos.RecNo := ProdutoEditandoID;
      mtProdutos.Edit;
    end
    else
      mtProdutos.Append;

    mtProdutosid.Value := 0;
    mtProdutosnumero_pedido.Value := StrToIntDef(edtPedidoNumero.Text, 0);
    mtProdutoscodigo_produto.Value := CodigoProduto;
    mtProdutosdescricao_produto.Value := stProdutoDescricao.Caption;
    mtProdutosquantidade.Value := Quantidade;
    mtProdutosvalor_unitario.Value := ValorUnitario;
    mtProdutosvalor_total.Value := ValorTotal;
    mtProdutos.Post;

    AtualizaTotalPedido;

    LimpaCamposProdutos;
    edtProdutoCodigo.SetFocus;
  except
    on E: Exception do
      Application.MessageBox(PChar('Erro: ' + E.Message), 'Erro', MB_ICONERROR + MB_OK);
  end;
end;

procedure TFrmPedido.btnGravarClick(Sender: TObject);
var
  Pedido: TPedido;
  Produto: TProdutoPedido;
  Ok: Boolean;
begin
  if Trim(edtClienteCodigo.Text) = '' then
  begin
    Application.MessageBox('Informe o cliente.', 'Aviso', MB_ICONWARNING + MB_OK);
    Exit;
  end;

  if mtProdutos.IsEmpty then
  begin
    Application.MessageBox('Adicione ao menos um produto.', 'Aviso', MB_ICONWARNING + MB_OK);
    Exit;
  end;

  Pedido := TPedido.Create;
  try
    Pedido.Numero := StrToIntDef(edtPedidoNumero.Text, 0);
    Pedido.DataEmissao := Now;
    Pedido.CodigoCliente := StrToInt(edtClienteCodigo.Text);
    Pedido.ValorTotal := StrToFloatDef(stPedidoTotal.Caption, 0);

    mtProdutos.First;
    while not mtProdutos.Eof do
    begin
      Produto := TProdutoPedido.Create;
      Produto.Id := mtProdutosid.AsInteger;
      Produto.NumeroPedido := Pedido.Numero;
      Produto.CodigoProduto := mtProdutoscodigo_produto.AsInteger;
      Produto.Quantidade := mtProdutosquantidade.AsInteger;
      Produto.ValorUnitario := mtProdutosvalor_unitario.AsFloat;
      Produto.ValorTotal := mtProdutosvalor_total.AsFloat;
      Pedido.Produtos.Add(Produto);

      mtProdutos.Next;
    end;

    Ok := TPedidoDAO.Create.GravarOuAlterarPedido(Pedido);
    if Ok then
    begin
      Application.MessageBox('Pedido gravado com sucesso!', 'Sucesso', MB_ICONINFORMATION + MB_OK);

      edtPedidoNumero.Text := IntToStr(Pedido.Numero);

      if Application.MessageBox('Deseja criar um novo pedido?', 'Novo Pedido', MB_YESNO + MB_ICONQUESTION) = IDYES then
      begin
        LimpaCampos;
        edtPedidoNumero.Text := '';
        edtClienteCodigo.SetFocus;
      end;
    end;
  finally
    Pedido.Free;
  end;
end;

procedure TFrmPedido.LimpaCamposProdutos;
begin
  edtProdutoCodigo.Clear;
  stProdutoDescricao.Caption := '';
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  stValorTotal.Caption := '0,00';
  ProdutoEditando := 0;
end;

procedure TFrmPedido.AtualizaTotalPedido;
var
  Total: Double;
  recn: Integer;
begin
  Total := 0;
  mtProdutos.DisableControls;
  recn := mtProdutos.recno;
  try
    mtProdutos.First;
    while not mtProdutos.Eof do
    begin
      Total := Total + mtProdutosvalor_total.AsFloat;
      mtProdutos.Next;
    end;
  finally
    mtProdutos.recno := recn;
    mtProdutos.EnableControls;
  end;

  stPedidoTotal.Caption := FormatFloat('##,##0.00', Total);
end;

procedure TFrmPedido.btnPesquisarClick(Sender: TObject);
var
  CDS: TClientDataSet;
  ValorSelecionado: Variant;
begin
  if Trim(edtPedidoNumero.Text) <> '' then
  begin
    PesquisarPedido(StrToIntDef(edtPedidoNumero.Text, 0));
    Exit;
  end;

  CDS := TPedidoDAO.ListarPedidos;
  try
    if TFrmPesquisaGenerica.ExecutarPesquisa(
      'Pesquisar Pedido',
      'numero_pedido',
      'numero_pedido',
      CDS,
      ValorSelecionado) then
    begin
      edtPedidoNumero.Text := VarToStr(ValorSelecionado);
      PesquisarPedido(StrToIntDef(edtPedidoNumero.Text, 0));
    end;
  finally
    CDS.Free;
  end;
end;

procedure TFrmPedido.btnPesquisarClienteClick(Sender: TObject);
var
  CDS: TClientDataSet;
  ValorSelecionado: Variant;
begin
  if Trim(edtClienteCodigo.Text) <> '' then
  begin
    BuscarClientePorCodigo(StrToIntDef(edtClienteCodigo.Text, 0));
    Exit;
  end;

  CDS := TClienteDAO.ListarClientes(TConexaoDB.GetConnection);
  try
    if FrmPesquisaGenerica.ExecutarPesquisa(
      'Pesquisar Cliente',
      'codigo',
      'nome',
      CDS,
      ValorSelecionado) then
    begin
      edtClienteCodigo.Text := VarToStr(ValorSelecionado);
      BuscarClientePorCodigo(StrToIntDef(edtClienteCodigo.Text, 0));
    end;
  finally
    CDS.Free;
  end;
end;

procedure TFrmPedido.btnPesquisarProdutoClick(Sender: TObject);
var
  CDS: TClientDataSet;
  ValorSelecionado: Variant;
begin
  if Trim(edtProdutoCodigo.Text) <> '' then
  begin
    BuscarProdutoPorCodigo(StrToIntDef(edtProdutoCodigo.Text, 0));
    Exit;
  end;

  CDS := TProdutoDAO.ListarProdutos(TConexaoDB.GetConnection);
  try
    if FrmPesquisaGenerica.ExecutarPesquisa(
      'Pesquisar Produto',
      'codigo',
      'descricao',
      CDS,
      ValorSelecionado) then
    begin
      edtProdutoCodigo.Text := VarToStr(ValorSelecionado);
      BuscarProdutoPorCodigo(StrToIntDef(edtProdutoCodigo.Text, 0));
    end;
  finally
    CDS.Free;
  end;
end;

procedure TFrmPedido.dbgProdutosDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TFrmPedido.dbgProdutosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (dbgProdutos.DataSource.DataSet.Active) and (dbgProdutos.DataSource.DataSet.RecordCount > 0) then
  begin
    dbgProdutos.Canvas.Brush.Color := clWhite;
    dbgProdutos.Canvas.Font.Color := clBlack;
    if (gdSelected in State) then
    begin
      dbgProdutos.Canvas.Font.Color := clMaroon;
      dbgProdutos.Canvas.Font.Style := [fsBold];
      dbgProdutos.Canvas.Brush.Color := $0091FFFF;
    end;
    dbgProdutos.Canvas.FillRect(Rect);
    dbgProdutos.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TFrmPedido.dbgProdutosTitleClick(Column: TColumn);
begin
  mtProdutos.IndexFieldNames := Column.FieldName;
end;

procedure TFrmPedido.edtClienteCodigoChange(Sender: TObject);
begin
  btnPesquisar.Visible := (Trim(edtClienteCodigo.Text) = '');
  btnCancelar.Visible := (Trim(edtClienteCodigo.Text) <> '');
end;

procedure TFrmPedido.edtClienteCodigoExit(Sender: TObject);
begin
  if Trim(edtClienteCodigo.Text) <> '' then
    BuscarClientePorCodigo(StrToIntDef(edtClienteCodigo.Text, 0))
  else
    LimpaCamposCliente;
end;

procedure TFrmPedido.edtClienteCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmPedido.edtPedidoNumeroExit(Sender: TObject);
begin
  if Trim(edtPedidoNumero.Text) <> '' then
    PesquisarPedido(StrToIntDef(edtPedidoNumero.Text, 0))
  else
    LimpaCampos;
end;

procedure TFrmPedido.edtPedidoNumeroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmPedido.BuscarClientePorCodigo(Codigo: Integer);
var
  Cliente: TCliente;
begin
  Cliente := TClienteDAO.BuscarPorCodigo(Codigo, TConexaoDB.GetConnection);
  if Assigned(Cliente) then
  begin
    stClienteNome.Caption := Cliente.Nome;
    stClienteCidade.Caption := Cliente.Cidade;
    stClienteUF.Caption := Cliente.UF;
    Cliente.Free;
  end
  else
  begin
    Application.MessageBox('Cliente não encontrado.', 'Aviso', MB_ICONWARNING + MB_OK);
    LimpaCamposCliente;
    edtClienteCodigo.SelectAll;
    edtClienteCodigo.SetFocus;
  end;
end;

procedure TFrmPedido.edtProdutoCodigoExit(Sender: TObject);
begin
  if Trim(edtProdutoCodigo.Text) <> '' then
    BuscarProdutoPorCodigo(StrToIntDef(edtProdutoCodigo.Text, 0))
  else
    LimpaCamposProdutos;
end;

procedure TFrmPedido.edtProdutoCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmPedido.edtQuantidadeChange(Sender: TObject);
begin
  CalcularTotalProduto;
end;

procedure TFrmPedido.edtValorUnitarioChange(Sender: TObject);
begin
  CalcularTotalProduto;
end;

procedure TFrmPedido.edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
var
  S: string;
  Edit: TEdit;
begin
  Edit := Sender as TEdit;
  S := Edit.Text;
  if Key in ['0'..'9', #8] then
    Exit;

  if (Key = ',') and (Pos(',', S) = 0) and (Pos('.', S) = 0) then
    Exit;

  if (Key = '.') and (Pos(',', S) = 0) and (Pos('.', S) = 0) then
  begin
    Key := ',';
    Exit;
  end;

  Key := #0;
end;

procedure TFrmPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (Application.MessageBox('Deseja realmente Sair do Sistema?', 'Atenção', MB_YESNOCANCEL + MB_ICONQUESTION) <> IDYES) then
  begin
    Action := caNone;
    Exit;
  end;

  try
    TConexaoDB.GetConnection.Connected := False;
  except
    on E: Exception do
      Application.MessageBox(PChar('Erro ao fechar conexão:' + sLineBreak + E.Message),
        'Atenção', MB_ICONWARNING + MB_OK);
  end;
end;

procedure TFrmPedido.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    if (Trim(edtPedidoNumero.Text) <> '') and (mtProdutos.RecordCount > 0) and
      (Application.MessageBox('Deseja criar um novo pedido?', 'Novo Pedido', MB_YESNO + MB_ICONQUESTION) = IDYES) then
    begin
      LimpaCampos;
      edtPedidoNumero.Text := '';
      edtClienteCodigo.SetFocus;
    end;
  end;
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
  try
    LimpaCampos;
    TConexaoDB.GetConnection.Connected := True;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao conectar no banco de dados:' + sLineBreak + E.Message),
        'Erro de Conexão', MB_ICONERROR + MB_OK);
      Application.Terminate;
    end;
  end;
end;

procedure TFrmPedido.PesquisarPedido(Numero: Integer);
var
  Pedido: TPedido;
  Cliente: TCliente;
begin
  Pedido := TPedidoDAO.Create.PesquisarPedido(Numero);
  if Assigned(Pedido) then
  begin
    edtPedidoNumero.Text := IntToStr(Pedido.Numero);
    stPedidoDataEmissao.Caption := DateToStr(Pedido.DataEmissao);
    stPedidoTotal.Caption := FormatFloat('##,##0.00', Pedido.ValorTotal);

    Cliente := TClienteDAO.BuscarPorCodigo(Pedido.CodigoCliente, TConexaoDB.GetConnection);
    if Assigned(Cliente) then
    begin
      edtClienteCodigo.Text := IntToStr(Cliente.Codigo);
      stClienteNome.Caption := Cliente.Nome;
      stClienteCidade.Caption := Cliente.Cidade;
      stClienteUF.Caption := Cliente.UF;
      Cliente.Free;
    end
    else
    begin
      LimpaCamposCliente;
    end;

    mtProdutos.DisableControls;
    try
      mtProdutos.Close;
      mtProdutos.Open;
      mtProdutos.EmptyDataSet;
      for var Prod in Pedido.Produtos do
      begin
        mtProdutos.Append;
        mtProdutosid.Value := Prod.Id;
        mtProdutosnumero_pedido.Value := Prod.NumeroPedido;
        mtProdutoscodigo_produto.Value := Prod.CodigoProduto;
        mtProdutosdescricao_produto.Value := Prod.DescricaoProduto;
        mtProdutosquantidade.Value := Prod.Quantidade;
        mtProdutosvalor_unitario.Value := Prod.ValorUnitario;
        mtProdutosvalor_total.Value := Prod.ValorTotal;
        mtProdutos.Post;
      end;
    finally
      mtProdutos.EnableControls;
    end;

    Pedido.Free;
  end
  else
  begin
    Application.MessageBox('Pedido não encontrado.', 'Aviso', MB_ICONWARNING + MB_OK);
    LimpaCampos;
    edtPedidoNumero.Text := IntToStr(Numero);
    edtPedidoNumero.SetFocus;
  end;
end;

procedure TFrmPedido.setProdutoEditando(valor: Integer);
begin
  ProdutoEditandoID := valor;
  if (valor = 0) then
  begin
    edtProdutoCodigo.ReadOnly := False;
    btnPesquisarProduto.Enabled := True;
    edtProdutoCodigo.Color := clWindow;
  end
  else
  begin
    edtProdutoCodigo.ReadOnly := True;
    btnPesquisarProduto.Enabled := False;
    edtProdutoCodigo.Color := $0091FFFF;
  end;
end;

procedure TFrmPedido.btnPDFClick(Sender: TObject);
begin
  if (not mtProdutos.IsEmpty) or (edtPedidoNumero.Text = '') then
  begin
    Application.MessageBox('Informe o Pedido.', 'Aviso', MB_ICONWARNING + MB_OK);
    Exit;
  end;

  ExportarPedidoParaHTML;
end;

procedure TFrmPedido.LimpaCampos;
begin
  btnPesquisar.Visible := True;
  btnCancelar.Visible := False;

  edtPedidoNumero.Text := '';
  stPedidoDataEmissao.Caption := DateToStr(Date);

  LimpaCamposCliente;
  LimpaCamposProdutos;

  stPedidoTotal.Caption := '0,00';

  mtProdutos.Close;
  mtProdutos.Open;
  mtProdutos.EmptyDataSet;
end;

procedure TFrmPedido.LimpaCamposCliente;
begin
  edtClienteCodigo.Text := '';
  stClienteNome.Caption := '';
  stClienteCidade.Caption := '';
  stClienteUF.Caption := '';
end;

procedure TFrmPedido.BuscarProdutoPorCodigo(Codigo: Integer);
var
  Produto: TProduto;
begin
  Produto := TProdutoDAO.BuscarPorCodigo(Codigo, TConexaoDB.GetConnection);
  if Assigned(Produto) then
  begin
    stProdutoDescricao.Caption := Produto.Descricao;
    edtValorUnitario.Text := FormatFloat('0.00', Produto.PrecoVenda);
    Produto.Free;
  end
  else
  begin
    Application.MessageBox('Produto não encontrado.', 'Aviso', MB_ICONWARNING + MB_OK);
    LimpaCamposProdutos;
    edtProdutoCodigo.SelectAll;
    edtProdutoCodigo.SetFocus;
  end;
end;

procedure TFrmPedido.CalcularTotalProduto;
var
  Quantidade: Integer;
  ValorUnitario, ValorTotal: Double;
begin
  if TryStrToInt(edtQuantidade.Text, Quantidade) and
    TryStrToFloat(edtValorUnitario.Text, ValorUnitario) then
  begin
    ValorTotal := Quantidade * ValorUnitario;
    stValorTotal.Caption := FormatFloat('0.00', ValorTotal);
  end
  else
  begin
    stValorTotal.Caption := '0,00';
  end;
end;

procedure TFrmPedido.ExportarPedidoParaHTML;
var
  SL: TStringList;
  i: Integer;
  FileName: string;
begin
  // Sugira o nome do arquivo (na pasta do exe)
  FileName := ExtractFilePath(Application.ExeName) + 'pedido_' + edtPedidoNumero.Text + '.html';

  SL := TStringList.Create;
  try
    SL.Add('<html><head><meta charset="ANSI"><title>Pedido</title></head><body>');
    SL.Add('<h2>Pedido Nº ' + edtPedidoNumero.Text + '</h2>');
    SL.Add('<b>Data:</b> ' + stPedidoDataEmissao.Caption + '<br>');
    SL.Add('<b>Cliente:</b> ' + stClienteNome.Caption + ' (' + edtClienteCodigo.Text + ')<br>');
    SL.Add('<b>Cidade/UF:</b> ' + stClienteCidade.Caption + '/' + stClienteUF.Caption + '<br>');
    SL.Add('<b>Total:</b> ' + stPedidoTotal.Caption + '<br><br>');
    SL.Add('<table border="1" cellpadding="4" cellspacing="0">');
    SL.Add('<tr><th>Cód</th><th>Descrição</th><th>Qtd</th><th>Unitário</th><th>Total</th></tr>');
    mtProdutos.First;
    for i := 1 to mtProdutos.RecordCount do
    begin
      SL.Add('<tr>' +
        '<td>' + mtProdutoscodigo_produto.AsString + '</td>' +
        '<td>' + mtProdutosdescricao_produto.AsString + '</td>' +
        '<td align="right">' + mtProdutosquantidade.AsString + '</td>' +
        '<td align="right">' + FormatFloat('0.00', mtProdutosvalor_unitario.AsFloat) + '</td>' +
        '<td align="right">' + FormatFloat('0.00', mtProdutosvalor_total.AsFloat) + '</td>' +
        '</tr>');
      mtProdutos.Next;
    end;
    SL.Add('</table>');
    SL.Add('</body></html>');
    SL.SaveToFile(FileName);
    Application.MessageBox(PChar('Arquivo exportado: ' + FileName), 'Exportação', MB_OK + MB_ICONINFORMATION);
    ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL); // Abre no navegador padrão
  finally
    SL.Free;
  end;
end;

end.

