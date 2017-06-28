using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using BluSoftService.Repository;

namespace BluSoftService.Service
{
    public class BluSoftService
    {
        private DatabaseConn context = new DatabaseConn();

        public Cliente ObterCliente(int codigo)
        {
            var cliente = context.Cliente.Where(s => s.Codigo == codigo).FirstOrDefault();

            return cliente;

        }

        public Cliente ObterCliente(string cpf)
        {
            var cliente = context.Cliente.Where(s => s.CPF == cpf).FirstOrDefault();

            return cliente;

        }

        public List<Cliente> BuscarCliente(string tipoPesquisa, string valorPesquisa)
        {
            List<Cliente> clientes = null;

            if (tipoPesquisa == "NOME")
                clientes = context.Cliente.Where(s => s.Nome.ToLower().Contains(valorPesquisa.ToLower())).ToList();
            else if (tipoPesquisa == "CPF")
                clientes = context.Cliente.Where(s => s.CPF == valorPesquisa).ToList();

            return clientes;

        }

        public List<Cliente> RelatorioCliente()
        {
            List<Cliente> clientes = null;

                clientes = context.Cliente.ToList();

            return clientes;

        }

        public bool ConfirmarCliente(Cliente cliente)
        {

            try
            {
                if (cliente.Codigo == 0)
                {
                    context.AddToCliente(cliente);
                }
                else
                {
                    var clienteUpdate = ObterCliente(cliente.Codigo);
                    clienteUpdate.CPF = cliente.CPF;
                    clienteUpdate.RG = cliente.RG;
                    clienteUpdate.Nome = cliente.Nome;
                    clienteUpdate.DataNascimento = cliente.DataNascimento;
                    clienteUpdate.Telefone = cliente.Telefone;
                    clienteUpdate.UF = cliente.UF;

                }

                context.SaveChanges();

                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool ExcluirCliente(int codigo)
        {
            try
            {
                var cliente = ObterCliente(codigo);
                context.DeleteObject(cliente);
                context.SaveChanges();

                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

    }
}
