# TesteBluSoft
Considerações: 
<l> Apontar no arquivo Web.config localizado no projeto BluSoft para o diretório onde se localiza o banco de dados:
add name="DatabaseConn" connectionString="metadata=res://*/Repository.Dadabase.csdl|res://*/Repository.Dadabase.ssdl|res://*/Repository.Dadabase.msl;provider=System.Data.SqlClient;provider connection string=&quot;Data Source=.\SQLEXPRESS;AttachDbFilename= D:\Users\Pedro\Documents\Projetos\Git\Local\TesteBluSoft 1.0\BluSoftService\Repository\Database.mdf) ;Integrated Security=True;User Instance=True;MultipleActiveResultSets=True&quot;" providerName="System.Data.EntityClient"/>
