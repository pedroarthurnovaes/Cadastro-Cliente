<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="Cliente.aspx.cs"
    Inherits="Cliente" %>

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
        
        $(document).ready(function () {
            CarregaForm();
        });

        function CarregaForm() {

            $(".loading").fadeIn("slow");

            $("#btnConfirmar").click(function () {

                if ($('#txtNome').val() == "") {
                    exibeCampoObrigatorio($('#txtNome'));
                    $('#txtNome').focus();
                    return false;
                }

                if ($('#txtCpf').val() == "") {
                    exibeCampoObrigatorio($('#txtCpf'));
                    $('#txtCpf').focus();
                    return false;
                }

                if (!validaCpf($('#txtCpf').val().trim())) {
                    exibeCampoObrigatorio($('#txtCpf'), "CPF inválido!");
                    $('#txtCpf').focus();
                    return false;
                }

                if ($('#txtNome').val() == "") {
                    exibeCampoObrigatorio($('#txtNome'));
                    $('#txtNome').focus();
                    return false;
                }

                if ($('#txtDataNascimento').val() == "") {
                    exibeCampoObrigatorio($('#txtDataNascimento'));
                    $('#txtDataNascimento').focus();
                    return false;
                }

                if ($('#txtTelefone').val() == "") {
                    exibeCampoObrigatorio($('#txtTelefone'));
                    $('#txtTelefone').focus();
                    return false;
                }

                if (!validaData($('#txtDataNascimento').val().trim())) {
                    exibeCampoObrigatorio($('#txtDataNascimento'), "Data inválida!");
                    $('#txtDataNascimento').focus();
                    return false;
                }

                if ($('#ddlUF option:selected').val() == "Selecionar") {
                    exibeCampoObrigatorio($('#ddlUF'));
                    $('#ddlUF').focus();
                    return false;
                }

                if ($('#ddlUF option:selected').val() == "SC") {
                    if ($('#txtRg').val() == "") {
                        exibeCampoObrigatorio($('#txtRg'));
                        $('#txtRg').focus();
                        return false;
                    }
                }
                else {
                    $('#txtRg').val('');
                }

                confirmarCliente();

            });
			
			$("#ddlUF").change(function () {
				exibeError($('#ddlUF'), false);	
                var valor = $('#ddlUF option:selected').val();
				
				if (valor == "SC") {
					$("#divRG").fadeIn("slow");
				}
				else {
					$("#divRG").fadeOut("slow");
				}
				
			});

			$("#btnOk").click(function () {
			    window.location.href = "ConsultaCliente.aspx";
			});


			$(".loading").fadeOut("slow");

        }
		
		function confirmarCliente(){

		    var param = JSON.stringify({
		        codigo: $("#codCliente").val(),
			    cpf: $("#txtCpf").val().replace(/\D/g, ''),
				rg: $("#txtRg").val().replace(/\D/g, ''),
				nome: $("#txtNome").val(),
				nascimento: $("#txtDataNascimento").val(),
				telefone: $("#txtTelefone").val(),
				uf: $('#ddlUF option:selected').val()
            });
			
			$.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: 'Cliente.aspx/ConfirmarCliente',
				data: param,
                dataType: "json",
                async: true,
                success: function (response) {
                    // Exibe uma mensagem de erro
                    $("#MensagemSucesso").modal("show");
                    $("#TextoMensagemSucesso").text('Cliente cadastrado com sucesso!');
                    
                },
                error: function (response) {
					// Exibe uma mensagem de erro
					$("#MensagemErro").modal("show");
					$("#TextoMensagemErro").text('Erro ao cadastrar cliente');
                }
            });
			
		}


		function obterCliente(codigo) {

		    var param = JSON.stringify({
		        codigo: codigo
		    });

		    $.ajax({
		        type: "POST",
		        contentType: "application/json; charset=utf-8",
		        url: 'Cliente.aspx/ObterCliente',
		        data: param,
		        dataType: "json",
		        async: true,
		        success: function (response) {
		            var cliente = response.d;

		            if (cliente != null) {
		                // carregamos o formulario com o resultado da consulta
		                $("#codCliente").val(cliente.Codigo);
		                $("#txtCpf").val(cliente.CPF);
		                $("#txtRg").val(cliente.RG);
		                $("#txtNome").val(cliente.Nome);
		                $("#txtDataNascimento").val(toDate(cliente.DataNascimento));
		                $("#txtTelefone").val(cliente.Telefone);
		                $('#ddlUF').val(cliente.UF);
		            }

		        },
		        error: function (response) {
		            // Exibe uma mensagem de erro
		            $("#MensagemErro").modal("show");
		            $("#TextoMensagemErro").text('Erro ao obter cliente');
		        }
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
                <div class="col-md-8">
                    <div class="panel-body">
                        <div class="row row-margin">
                            <div class="panel panel-default">
                                <div class="panel-heading panel-font">
                                    Cadastro Cliente
                                </div>

                                <div class="panel-body">
                                    <input type="hidden" id="codCliente" name="codCliente" value="" />
                                    <div class="row">
                                        <div class="col-md-10">
                                            <div class="form-group">
												<label>Nome:</label>
												<input ID="txtNome" data-required="true" class="form-control input-capitalize" />
											</div>
                                        </div>
                                    </div>   
									<div class="row">
                                        <div class="col-md-5">
                                            <div class="form-group">
												<label>CPF:</label>
												<input ID="txtCpf" data-required="true" class="form-control input-cpf"/>
											</div>
                                        </div>
										<div id="divRG" class="col-md-5">
                                            <div class="form-group">
												<label>RG:</label>
												<input id="txtRg" data-required="true" class="form-control input-numeric" />
											</div>
                                        </div>
                                    </div>
									
									<div class="row">
                                        <div class="col-md-5">
                                            <div class="form-group">
												<label>Data de Nascimento:</label>
												<input ID="txtDataNascimento" data-required="true" class="form-control input-date" />
											</div>
                                        </div>
										<div class="col-md-5">
                                            <div class="form-group">
												<label>Telefone:</label>
												<input ID="txtTelefone" data-required="true" class="form-control input-phone" />
											</div>
                                        </div>
                                    </div>
									<div class="row">
                                        <div class="col-md-5">
                                            <div class="form-group">
												<label>UF:</label>
												<select ID="ddlUF" class="form-control">
													<option>Selecionar</option>
													<option>SC</option>
													<option>PR</option>
												</select>
											</div>
                                        </div>
                                    </div>
									
									<br/>
									
									<div class="row align-center">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <button type="button" id="btnConfirmar" usesubmitbehavior="False" class="btn btn-primary">
                                                    <i class="fa fa-check"></i> Confirmar</button>
                                            </div>
                                        </div>
                                    </div>
                            </div>
                                
                        </div>
                    </div>
                    <div class="row align-left">
                        <div class="col-md-12">
                            <div class="form-group">
                                <a href='ConsultaCliente.aspx' class="btn btn-info"> Buscar cliente </a>
                            </div>
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
    <div class="modal fade alert" id="MensagemErro" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog alert-danger" style="width: 450px">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">
                        Titulo da Mensagem
                    </h4>
                </div>
                <div class="modal-body align-center" style="font-size: 18px !important;" id="TextoMensagemErro">
                    Mensagem de Erro
                </div>
                <div class="modal-footer">
                    <button id="btnErro" type="button" class="btn btn-danger center-block" data-dismiss="modal">
                        OK</button>
                </div>
            </div>
        </div>
    </div>
</form>
</body>


<script language="javascript" type="text/javascript">

    if (request("codigo") != '') {
        obterCliente(request("codigo"));
    }

</script>



</html>
