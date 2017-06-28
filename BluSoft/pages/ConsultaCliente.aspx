<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="ConsultaCliente.aspx.cs"
    Inherits="ConsultaCliente" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge; IE=11; IE=10; IE=9; IE=8; IE=7" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    
	<title>BluSoft</title>
    <link rel="stylesheet" type="text/css" href="../style/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../style/bootstrap-theme.min.css" />
    <link rel="stylesheet" type="text/css" href="../style/sb-admin-2.min.css" />
    <link rel="stylesheet" type="text/css" href="../style/jquery-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="../style/metisMenu/metisMenu.min.css" />
    <link rel="stylesheet" type="text/css" href="../style/font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="../style/default.css" />
    
    <link rel="stylesheet" type="text/css" href="../style/cliente.css" />

    <script language="javascript" type="text/javascript" src="../scripts/jquery-3.1.1.min.js"></script>
    <script language="javascript" type="text/javascript" src="../scripts/jquery.mask.min.js"></script>
    <script language="javascript" type="text/javascript" src="../scripts/jquery.maskMoney.js"></script>
    <script language="javascript" type="text/javascript" src="../scripts/bootstrap.js"></script>
    
    <script language="javascript" type="text/javascript" src="../scripts/metisMenu/metisMenu.js"></script>
    <script language="javascript" type="text/javascript" src="../scripts/sb-admin-2.js"></script>
    <script language="javascript" type="text/javascript" src="../scripts/default.js"></script>
    
    <script language="javascript" type="text/javascript">

        var CodCliente;
        var TipoPesquisa;
        var ValorPesquisa;

        // iniciamos o jquery
        $(document).ready(function () {
            CarregaForm();
        });

        // carregamos o tela
        function CarregaForm() {
            
            // exibimos a animação do loading
            $(".loading").fadeIn("slow");

            // evento click do botão pesquisa
            $("#txtPesquisa").keypress(function (event) {
                
                var busca = $("[name=optBusca]:checked").val();
                if (busca != 'NOME') {
                    return isKeyNumeric(event);
                }

            });

            $("#txtPesquisa").keydown(function (event) {
                var busca = $("[name=optBusca]:checked").val();
                if (busca != 'NOME') {
                    if (!isNumeric($(this).val()))
                        $(this).val('');
                }

            }); 


            $("#btnBuscar").click(function () {
                consultaCliente();
            });

            $("#btnExcluir").click(function () {
                if (CodCliente != null)
                    excluiCliente(CodCliente);
            });

            $("#btnRelatorio").click(function () {
                relatorioCliente();
            });
			
            // configuramos a máscara para o controle de pesquisa
            var busca = $("[name=optBusca]:checked").val()
            if (busca == 'CPF') {
                $('#txtPesquisa').mask('999.999.999-99', { placeholder: 'CPF do cliente' });
            }
            else if (busca == 'NOME') {
                $('#txtPesquisa').attr('placeholder', 'Nome do cliente');
                $("#txtPesquisa").unmask();
            }

            // método para carregar o tipo de pesquisa
            $('input[type=radio][name=optBusca]').change(function () {

                if (this.value == 'CPF') {
                    $('#txtPesquisa').mask('999.999.999-99', { placeholder: 'Informe o CPF' });
                
                }
                else if (this.value == 'NOME') {
                    $('#txtPesquisa').attr('placeholder', 'Informe o nome');
                    $("#txtPesquisa").unmask();

                }

                $('#txtPesquisa').val('');
                exibeError($('#txtPesquisa'), false);
                $('#txtPesquisa').focus();

            });

            $("input[name=optBusca][id=optCPF]").prop('checked', true);
            $('#txtPesquisa').mask('999.999.999-99', { placeholder: 'CPF do cliente' });
            $("#txtPesquisa").val('');
            $('#txtPesquisa').focus();

            $(".loading").fadeOut("slow");

        }

        function consultaCliente() {

            try {

                if (validaPesquisa()) {

                    $(".loading").fadeIn("slow");
                    $("#divListaResultado").slideUp();

                    var tipoPesquisa = $("[name=optBusca]:checked").val();
                    var valorPesquisa = $("#txtPesquisa").val();

                    if (tipoPesquisa == "CPF") {
                        valorPesquisa = valorPesquisa.replace(/\D/g, '')
                    }

                    var param = JSON.stringify({
                        valorPesquisa: valorPesquisa,
                        tipoPesquisa: tipoPesquisa
                    });
                    
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: 'ConsultaCliente.aspx/BuscarCliente',
                        data: param,
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            // obtemos o resultado do método
                            var listaResultado = response.d;

                            // verificamos o resultado do método
                            if (listaResultado != null && listaResultado.length > 0) {
                                // limpamos todos os registros na grid(table)
                                $("#table-resultado tbody tr").remove();

                                $(".loading").fadeOut("slow");

                                // inserimos um registro na grid
                                carregaPesquisa(listaResultado);
                                    
                                // exibimos a div com a grid 
                                $("#divListaResultado").slideDown();

                                TipoPesquisa = tipoPesquisa;
                                ValorPesquisa = valorPesquisa;

                            }
                            else {
                                $(".loading").fadeOut("slow");
                                exibeCampoObrigatorio($('#txtPesquisa'), "Sem resultado(s) para esta pesquisa!");
                            }

                        },
                        error: function (response) {
                            $("#table-resultado tbody tr").remove();

                            $(".loading").fadeOut("slow");

                            // Exibe uma mensagem de erro
                            $("#MensagemErro").modal("show");
                            $("#TextoMensagemErro").text('Mensagem de Erro!');

                            //window.location.href = "Erro.html";

                        }
                    })

                }

            }
            catch (Erro) {
                $(".loading").fadeOut("slow");
                $("#MensagemErro").text('Erro ao validar os dados do cliente!');
                $("#modalErro").modal("show");
                return false;
            }
        }

        function relatorioCliente() {

            try {


                    $(".loading").fadeIn("slow");
                    $("#divListaResultado").slideUp();

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: 'ConsultaCliente.aspx/RelatorioCliente',
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            // obtemos o resultado do método
                            var listaResultado = response.d;

                            // verificamos o resultado do método
                            if (listaResultado != null && listaResultado.length > 0) {
                                // limpamos todos os registros na grid(table)
                                $("#table-resultado tbody tr").remove();

                                $(".loading").fadeOut("slow");

                                // inserimos um registro na grid
                                carregaPesquisa(listaResultado);

                                // exibimos a div com a grid 
                                $("#divListaResultado").slideDown();

                                TipoPesquisa = tipoPesquisa;
                                ValorPesquisa = valorPesquisa;

                            }
                            else {
                                $(".loading").fadeOut("slow");
                                exibeCampoObrigatorio($('#txtPesquisa'), "Sem resultado(s) para esta pesquisa!");
                            }

                        },
                        error: function (response) {
                            $("#table-resultado tbody tr").remove();

                            $(".loading").fadeOut("slow");

                            // Exibe uma mensagem de erro
                            $("#MensagemErro").modal("show");
                            $("#TextoMensagemErro").text('Mensagem de Erro!');

                            //window.location.href = "Erro.html";

                        }
                    })
            }
            catch (Erro) {
                $(".loading").fadeOut("slow");
                $("#MensagemErro").text('Erro ao validar os dados do cliente!');
                $("#modalErro").modal("show");
                return false;
            }
        }

        function excluiCliente(codigo) {

            try {

                $(".loading").fadeIn("slow");

                var param = JSON.stringify({
                    codigo: codigo
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: 'ConsultaCliente.aspx/ExcluirCliente',
                    data: param,
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        $(".loading").fadeOut("slow");

                        // obtemos o resultado do método
                        var resultado = response.d;

                        // verificamos o resultado do método
                        if (resultado) {
                            // Exibe uma mensagem de sucesso
                            $("#MensagemSucesso").modal("show");
                            $("#TextoMensagemSucesso").text('Cliente excluído com sucesso!');
                        }
                        else {
                            // Exibe uma mensagem de erro
                            $("#MensagemErro").modal("show");
                            $("#TextoMensagemErro").text('Não foi possível excluir o cliente!');
                        }

                    },
                    error: function (response) {

                        $(".loading").fadeOut("slow");

                        // Exibe uma mensagem de erro
                        $("#MensagemErro").modal("show");
                        $("#TextoMensagemErro").text('Mensagem de Erro!');

                    }
                })

            }
            catch (Erro) {
                $(".loading").fadeOut("slow");
                $("#MensagemErro").text('Erro ao validar os dados do cliente!');
                $("#modalErro").modal("show");
            }
        }

        function carregaPesquisa(listaResultado) {

            // para cada registro retornado
            $.each(listaResultado, function (index, item) {
                // inserimos um registro na grid
                insereTablePesquisa(item.Codigo, item.CPF, item.RG, item.Nome, item.DataNascimento, item.Telefone, item.UF);
            })


        }

        //////////////////////////////////////////////////////////////
        /// Método responsável por validar os campos do formulário ///
        //////////////////////////////////////////////////////////////
        function validaPesquisa() {

            var busca = $("[name=optBusca]:checked").val();

            if (busca == 'CPF') {

                if ($('#txtPesquisa').val() == "") {
                    exibeError($('#txtPesquisa'), true);
                    $('#txtPesquisa').focus();
                    return false;
                }

                if (!validaCpf($('#txtPesquisa').val().trim())) {
                    exibeCampoObrigatorio($('#txtPesquisa'), "CPF inválido!");
                    $('#txtPesquisa').focus();
                    return false;
                }
            }

            else if (busca == 'NOME') {
                if ($('#txtPesquisa').val() == "") {
                    exibeError($('#txtPesquisa'), true);
                    $('#txtPesquisa').focus();
                    return false;
                }

                if ($('#txtPesquisa').val().trim().length < 3) {
                    exibeCampoObrigatorio($('#txtPesquisa'), "Informe o mínimo 3 caracteres!");
                    return false;
                }

                $('#txtPesquisa').val(formataNome($('#txtPesquisa').val()));

            }
            
            $(".loading").fadeIn("slow");
            return true;

        }

        
        ////////////////////////////////////////////////////////////
        /// Método responsável por adicionar um registro na grid ///
        ////////////////////////////////////////////////////////////
        function insereTablePesquisa(codigo, cpf, rg, nome, nascimento, telefone, uf) {
            // obtemos a quantidade de registro
            var indice = $("#table-resultado tr").length

            // montamos o html da tabela que será nosso grid
            var text = "";
            text += "<tr>";
            text += "   <td>" + cpf + "</td>";
            text += "   <td>" + nome + "</td>";
            text += "   <td style='vertical-align:middle; text-align:center'>" + toDate(nascimento) + "</td>";
            text += "   <td style='vertical-align:middle; text-align:center'>" + telefone + "</td>";
            text += "   <td style='vertical-align:middle; text-align:center'>" + uf + "</td>";
            //text += "   <td><span class='glyphicon glyphicon-check selecionarItem' data-cod='" + codigo + "' data-nome='" + nome + "' data-toggle='tooltip' data-placement='top' title='editar' />&nbsp;&nbsp;<span class='glyphicon glyphicon-trash color-red removerItem' data-cod='" + codigo + "' data-toggle='tooltip' data-placement='top' title='remover' /></td>";
            text += "   <td style='vertical-align:middle; text-align:center'>";
            text += "   <a href='#' class='removerItem btn btn-outline btn-danger btn-xs glyphicon glyphicon-remove' data-cod='" + codigo + "' data-nome='" + nome + "' data-toggle='tooltip' data-placement='top' title='excluir cliente' />";
            text += "   <a href='Cliente.aspx?codigo=" + codigo + "' class='btn btn-outline btn-primary btn-xs glyphicon glyphicon-edit' data-toggle='tooltip' data-placement='top' title='editar cliente' />";
            text += "   </td>";
			text += "</tr>";

			// obtemos o controle tr da table
			var table = $("#table-resultado tbody");

			// adicionamos uma linha
			table.append(text);

            // evendo click responsavel por remover um item no grid
			$(".removerItem").off("click").on("click", function () {

			    // obtemos o valor do atributo html que contem o código da linha selecionada
			    var codigo = $(this).attr('data-cod');
			    var nome = $(this).attr('data-nome');

			    CodCliente = codigo;

			    // Exibe uma mensagem de erro
			    $("#MensagemExcluir").modal("show");
			    $("#TextoMensagemExcluir").text('Deseja realmente excluir o cliente ' + nome);

			});

        }

        
</script>

</head>

<body class="fadeIn">
    <form id="form1" autocomplete="off" runat="server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    
    <div class="loading"></div>
    
    <div class="container">
        <div class="content">
            <div class="row">
                <div class="col-md-12">
                    <h3 id="divTitulo" class="page-header">
                        Cliente</h3>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="panel-body">
                        <div class="row row-margin">
                            <div class="panel panel-default">
                                <div class="panel-heading panel-font">
                                    Consulta Cliente
                                </div>

                                <div class="panel-body">
                                    <div class="form-group">
                                        <label class="radio-inline">
                                            <input runat="server" type="radio" name="optBusca" id="optCPF" value="CPF" />CPF
                                        </label>
                                        <label class="radio-inline">
                                            <input runat="server" type="radio" name="optBusca" id="optNome" value="NOME" />Nome
                                        </label>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <input ID="txtPesquisa" data-required="true" class="form-control" />
                                            </div>

                                            <div class ="row align-left">
                                                <div class="col-md-2">
                                                    <button type="button" id="btnRelatorio" usesubmitbehavior="False" class="btn btn-primary"> Relatório de clientes </button>
                                                </div>
                                                
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-8">
                                            <div class="form-group">
                                                <button type="button" id="btnBuscar" class="btn btn-default">
                                                    <i class="fa fa-search"></i> Buscar</button>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div id="divListaResultado" class="row display-none">
                                                <div class="col-md-12 bs-glyphicons">
                                                    <hr />
                                                    <table width="100%" class="table table-striped table-hover" id="table-resultado">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 130px">
                                                                    CPF
                                                                </th>
                                                                <th style="width: 200px">
                                                                    Nome
                                                                </th>
                                                                <th style="width: 130px; text-align: center">
                                                                    Data Nascimento
                                                                </th>
                                                                <th style="width: 130px; text-align: center">
                                                                    Telefone
                                                                </th>
                                                                <th style="width: 100px; text-align: center">
                                                                    Região
                                                                </th>
                                                                <th style="width: 10px; text-align: center">
                                                                    Ações
                                                                </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>

                        <div class="form-group align-left">
                            <a href='Cliente.aspx' class="btn btn-info"> Cadastrar Cliente </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- mensagem de sucesso -->
    <div class="modal fade alert" id="MensagemSucesso" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog alert-info" style="width: 450px">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title" id="myModalLabel">
                        Titulo da Mensagem</h4>
                </div>
                <div class="modal-body align-center" style="font-size: 18px !important;" id="TextoMensagemSucesso">
                    Mensagem de Sucesso!
                </div>
                <div class="modal-footer">
                    <button id="btnOk" type="button" class="btn btn-primary center-block" data-dismiss="modal">
                        OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- mensagem de erro -->
    <div class="modal fade alert" id="MensagemExcluir" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog alert-danger" style="width: 450px">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">
                        Excluir Cliente
                    </h4>
                </div>
                <div class="modal-body align-center" style="font-size: 18px !important;" id="TextoMensagemExcluir">
                    Mensagem de Erro
                </div>
                <div class="modal-footer">
                <div class="row-margin">
                    <button id="btnExcluir" type="button" class="btn btn-danger align-left" data-dismiss="modal">
                            Confirmar</button>
                        <button id="bntCancelar" type="button" class="btn btn-default align-right" data-dismiss="modal">
                            Cancelar</button>
                    </div>
                </div>
                
            </div>
        </div>
    </div>

</form>
</body>

</html>
