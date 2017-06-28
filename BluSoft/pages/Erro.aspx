﻿<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="Erro.aspx.cs"
    Inherits="SessaoFinalizada" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
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
            $('#Voltar').click(function () {
                $(".loading").fadeIn("slow");
                //window.history.go(-2);
                window.location = window.history.back();
            });

            $('#protocolo').text(token())

        });

        var token = function () {
            //return Math.random().toString(36).substr(15);
            return " BNH5YZD";
        };

    </script>
</head>
<body class="fadeIn">
    <form id="form1" autocomplete="off" runat="server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <div class="loading">
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-red" style="border-color: #d9534f">
                    <div class="panel-heading" style="background-color: #d9534f">
                        <span>BluSoft</span>
                    </div>
                    <div class="panel-body">
                        <fieldset>
                            
                            <div class="alert alert-danger" style="background-color:transparent; border: none" >
                                <center>
                                    <i class="fa fa-warning" style="font-size:xx-large" ></i><br />
                                    <b>Bem, isto é contrangedor...</b><br />
                                    Ocorreu uma falha ao realizar sua operação.
                                    <br/><br />
                                    O suporte técnico já foi notificado!<br/>
                                    Se precisar entre em contato pelo atendimento.<br/><br/>
                                    Protocolo de identificação do erro:<b><span id="protocolo"></span></b>
                                </center>
                            </div>

                            <div class="form-group ">
                                <div class="text-center">
                                    <input type="button" id="Voltar" class="btn btn-lg btn-half-block btn-default" value="Voltar" />
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
