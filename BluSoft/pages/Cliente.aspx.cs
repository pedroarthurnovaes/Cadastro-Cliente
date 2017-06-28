using System;
using System.Web.Services;

using BluSoftService.Service;
using BluSoftService.Repository;

public partial class Cliente : System.Web.UI.Page
{

    #region Properties

    
    #endregion

    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack) {

            /*
            // Exemplo para carregar formulário
            var codigo = this.Request["codigo"];

            if (!string.IsNullOrEmpty(codigo))
            {
                BluSoftService.Service.BluSoftService service = new BluSoftService.Service.BluSoftService();

                var cliente = service.ObterCliente(Int32.Parse(codigo));

                // TODO: Carregamos os controles do formulario
                // carregaFormulario(cliente);

            }
            */
        }
    }

    #endregion

    #region Methods


    #endregion

    #region WebMethods

    [WebMethod(EnableSession = true)]
    public static bool ConfirmarCliente(string codigo, string cpf, string rg, string nome, string nascimento, string telefone, string uf)
    {
        
        try
        {
            BluSoftService.Service.BluSoftService service = new BluSoftService.Service.BluSoftService();

            var cliente = new BluSoftService.Repository.Cliente();
            cliente.CPF = cpf;
            cliente.RG = rg;
            cliente.Nome = nome;
            cliente.DataNascimento = Convert.ToDateTime(nascimento);
            cliente.Telefone = telefone;
            cliente.UF = uf;

            if (!string.IsNullOrEmpty(codigo))
                cliente.Codigo = Int32.Parse(codigo);

            return service.ConfirmarCliente(cliente);

        
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    [WebMethod(EnableSession = true)]
    public static BluSoftService.Repository.Cliente ObterCliente(int codigo)
    {

        try
        {
            BluSoftService.Service.BluSoftService service = new BluSoftService.Service.BluSoftService();

            return service.ObterCliente(codigo);


        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    #endregion

}

