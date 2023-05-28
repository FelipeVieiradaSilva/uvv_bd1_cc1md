-- Felipe Vieira da Silva 
-- CC1MD

--Aqui irá derrubar o banco de dados da uvv caso ele exista
DROP DATABASE IF EXISTS uvv;

--Aqui irá derrubar o usuário felipe caso ele exista
DROP USER IF EXISTS felipe;

--Irá criar o usuário felipe contendo o CREATEDB CREATE ROLE e uma senha criptografada que é felipe123
CREATE USER felipe WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD 'felipe123';

--Criação do banco de dados chamados uvv contendo o dono do banco de dados felipe template sendo 0 e a permitir a conexão
CREATE DATABASE uvv WITH
OWNER = felipe
TEMPLATE = template0 
ENCODING = 'UTF8'
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = true;
--Dará a conexão para o banco de dados uvv
\c uvv;
--Definirá o identificador do usuário como sendo o felipe
SET ROLE = felipe;
--Criará o schema lojas dando a autorização para o felipe
CREATE SCHEMA lojas
AUTHORIZATION felipe;
--Escolherá o schema atual e depois verá qual que é o caminho da busca
SELECT CURRENT_SCHEMA ();
SHOW SEARCH_PATH;
--Definirá o caminho da busca para lojas depois "$user" e por últmio public para depois ver como está o caminho da busca
SET SEARCH_PATH TO lojas, "$user", public;
SHOW SEARCH_PATH;
--Alterar o usuário para felipe e selecionar o caminho de busca para o mesmo dito anteriormente
ALTER USER felipe
SET SEARCH_PATH TO lojas, "$user", public;



--Criar tabela clientes:
--Os itens numeric so pode ser número e o que está em parêntesis é o número máximo que pode ser escrito nesta coluna 
--Varchar é o campo de caracter variado e pode conter letras e números e o número que está entre parêntesis indica a quantidade máxima que pode ser escrito nessa coluna
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);
--Aqui estão os comentários para as tabelas e para as colunas explicando o que cada um está identificando 
COMMENT ON TABLE lojas.clientes IS 'tabela clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'id do cliente cadastrado e também é a pk da tabela clientes';
COMMENT ON COLUMN lojas.clientes.email IS 'email do cliente cadastrado';
COMMENT ON COLUMN lojas.clientes.nome IS 'nome do cliente cadastrado';
COMMENT ON COLUMN lojas.clientes.telefone1 IS '1 telefone do cliente cadstrado';
COMMENT ON COLUMN lojas.clientes.telefone2 IS '2 telefone do cliente cadastrado';
COMMENT ON COLUMN lojas.clientes.telefone3 IS '3 telefone do cliente cadastrado';

--Criar a tabela produtos:
--O campo BYTEA armazena apenas dados binários e geralmente de grande volume, como documentos PDF, vídeos, imagens, entre outros
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);
--Aqui está uma constraint do tipo check para que o preco dos produtos não possa ser menos que 0 sendo assim ele será mais que zero
ALTER TABLE lojas.produtos
ADD CONSTRAINT preco_dos_produtos
CHECK (preco_unitario > 0);

COMMENT ON TABLE lojas.produtos IS 'tabela produtos';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'id do produto sendo também a pk da tabela produtos';
COMMENT ON COLUMN lojas.produtos.nome IS 'nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'valor unitário do produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'detalhes sobre o produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'indica o tipo de dado que a imagem contém';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'indica o arquivo da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'indica os caracteres da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'última atualização feita para a imagem';

--Criar tabela lojas
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);

COMMENT ON TABLE lojas.lojas IS 'tabela lojas';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'id da loja sendo também a pk da tabela lojas';
COMMENT ON COLUMN lojas.lojas.nome IS 'nome inteiro da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'endereço web em URL da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'endereço físico em que a loja está localizada';
COMMENT ON COLUMN lojas.lojas.latitude IS 'posição na vertical onde a loja está localizada';
COMMENT ON COLUMN lojas.lojas.longitude IS 'posição na horizontal onde a loja está localizadaa';
COMMENT ON COLUMN lojas.lojas.logo IS 'logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'indica o tipo de dado que a logo contém';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'indica o arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'indica os caracteres da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'última atualização feita para a logo';

--Criar tabela envios
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cleinte_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);
--Aqui está uma constraint para que as palavras escritas no campo de status possam ser apenas criado, enviado, transito e entregue
ALTER TABLE lojas.envios
ADD CONSTRAINT tipos_de_status 
CHECK (status IN ( 'CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

COMMENT ON TABLE lojas.envios IS 'tabela envios';
COMMENT ON COLUMN lojas.envios.envio_id IS 'id do envio sendo também a pk da tabela envios';
COMMENT ON COLUMN lojas.envios.loja_id IS 'id da loja que teve um produto enviado sendo também a fk da tabela';
COMMENT ON COLUMN lojas.envios.cleinte_id IS 'id do cliente que comprou o produto e está esperando o envio';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'endereço da entrega do produto que foi enviado';
COMMENT ON COLUMN lojas.envios.status IS 'status em que está o envio do pedido para o cliente';

--Criar tabela pedidos
--O campo TIMESTAMP é utilizado para armazenar datas e horários
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);
--Aqui está uma constraint para que as palavras escritas no campo de status possam ser apenas cancelado, completo, aberto, pago, rembolsado e enviado
ALTER TABLE lojas.pedidos
ADD CONSTRAINT tipo_de_status 
CHECK (status IN ( 'CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

COMMENT ON TABLE lojas.pedidos IS 'tabela pedidos';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'id do pedido que foi realizado sendo também a pk da tabela pedidos';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'data e a hora em que o pedido foi realizado';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'id do cliente que realizou o pedido e também é a fk entre clientes e pedidos';
COMMENT ON COLUMN lojas.pedidos.status IS 'status em que está o pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'id da loja e também é a fk entre lojas e pedidos';

--Criar tabela pedidos_itens
CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);
--Constraint para que o preço unitário dos pedidos possa ser apenas maior que zero, não podendo ser negativo ou zero
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT preco_dos_pedidos 
CHECK (preco_unitario > 0);

--Constraint para que a quantidade de pedidos possa ser 1 ou mais não podendo ser 0 ou negativo
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT quantidade_de_pedidos 
CHECK (quantidade >= 1);

COMMENT ON TABLE lojas.pedidos_itens IS 'tabela pedidos_itens';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'id do pedido do item sendo assim ele será umapk e fk ao mesmo tempo, logo ele será uma pfk';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'id do produto sendo assim ele será uma pk e fk ao mesmo tempo, logo ele será uma pfk';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'número da linha do item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'preço unitário do item pedido';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'quantidade do item que foi pedido';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'id do envio do item do pedido sendo assim ele será a fk da tabela';

--Criar tabela estoques
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE lojas.estoques IS 'tabela estoques';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'id do estoque sendo também a pk da tabela estoques';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'id da loja que tem os produtos em estoque sendo também a fk da tabela';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'id do produto que está em estoque sendo também a fk da tabela';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'quantidade de produtos que estão em estoque';

--Constraint do tipo foreign key para que tenha uma fk na tabela referente
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cleinte_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedids_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedids_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedids_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
