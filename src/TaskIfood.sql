CREATE DATABASE ifood;
USE ifood;

CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(60),
    bairro VARCHAR(30),
    numero VARCHAR(10),
    cidade VARCHAR(60),
    estado VARCHAR(30),
    pontoReferencia VARCHAR(60),
    complemento VARCHAR(60),
    cep VARCHAR(11),
    tipo_endereco ENUM('casa', 'apartamento', 'comercial')
);

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    descricao TEXT,
    tipo_categoria ENUM('restaurante', 'produto')
);

CREATE TABLE restaurante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    telefone VARCHAR(15),
    hora_funcionamento TIME,
    id_endereco_restaurante INT,
    is_retirada BOOLEAN,
    id_categoria INT,
    valorMinimoEntrega FLOAT,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id),
    FOREIGN KEY (id_endereco_restaurante) REFERENCES endereco(id)
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    preco FLOAT,
    id_categoria INT,
    id_restaurante INT,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id)
);

CREATE TABLE promocao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60),
    codigo VARCHAR(30),
    valor FLOAT,
    validade DATE,
    tipo VARCHAR(30)
);

CREATE TABLE acompanhamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    descricao TEXT,
    valor FLOAT
);

CREATE TABLE produtoAcompanhamento (
    id_produto INT, 
    id_acompanhamento INT,
    PRIMARY KEY(id_produto, id_acompanhamento),
    FOREIGN KEY (id_produto) REFERENCES produtos(id),
    FOREIGN KEY (id_acompanhamento) REFERENCES acompanhamento(id)
);

CREATE TABLE formaPagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    forma VARCHAR(60)
);

CREATE TABLE restaurantePagamento (
    id_restaurante INT,
    id_forma_pagamento INT,
    PRIMARY KEY (id_restaurante, id_forma_pagamento),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id),
    FOREIGN KEY (id_forma_pagamento) REFERENCES formaPagamento(id)
);

CREATE TABLE historicoDePagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dataPagamento DATE,
    id_forma_pagamento INT,
    valor FLOAT,
    FOREIGN KEY (id_forma_pagamento) REFERENCES formaPagamento(id)
);

CREATE TABLE statusEntrega (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60)
);

CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dataPedido DATE,
    id_restaurante INT,
    valor FLOAT,
    taxaEntrega FLOAT,
    id_promocao INT,
    id_forma_pagamento INT,
    observacoes TEXT,
    troco FLOAT,
    id_status_entrega INT,
    id_endereco INT,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id),
    FOREIGN KEY (id_promocao) REFERENCES promocao(id),
    FOREIGN KEY (id_forma_pagamento) REFERENCES formaPagamento(id),
    FOREIGN KEY (id_status_entrega) REFERENCES statusEntrega(id),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id)
);

CREATE TABLE historicoDeEntregas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_status_entrega INT,
    id_pedido INT,
    data_hora DATETIME, 
    FOREIGN KEY (id_status_entrega) REFERENCES statusEntrega(id),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

CREATE TABLE avaliacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota INT,
    id_pedido INT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

CREATE TABLE pedidoProduto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

CREATE TABLE pedidoProdutoAcompanhamento (
    id_pedido_produto INT,
    id_acompanhamento INT,
    PRIMARY KEY (id_pedido_produto, id_acompanhamento),
    FOREIGN KEY (id_pedido_produto) REFERENCES pedidoProduto(id),
    FOREIGN KEY (id_acompanhamento) REFERENCES acompanhamento(id)
);
