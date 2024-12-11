CREATE DATABASE IF NOT EXISTS ifood;
USE ifood;

CREATE TABLE IF NOT EXISTS endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(60) NOT NULL,
    bairro VARCHAR(30) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    ponto_referencia VARCHAR(60),
    complemento VARCHAR(60),
    cep VARCHAR(11) NOT NULL,
    tipo_endereco ENUM('Residencial', 'Comercial') NOT NULL
);

CREATE TABLE IF NOT EXISTS categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao TEXT,
    tipo_categoria ENUM('Alimentação', 'Bebida', 'Sobremesa') NOT NULL
);

CREATE TABLE IF NOT EXISTS restaurante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    telefone VARCHAR(20),
    hora_funcionamento TIME NOT NULL,
    id_endereco_restaurante INT NOT NULL,
    is_retirada BOOLEAN DEFAULT FALSE,
    id_categoria INT NOT NULL,
    valor_minimo_entrega DECIMAL(10, 2) DEFAULT 0.00,
    status BOOLEAN DEFAULT TRUE,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id) ON DELETE CASCADE,
    FOREIGN KEY (id_endereco_restaurante) REFERENCES endereco(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    preco DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    id_restaurante INT NOT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id) ON DELETE CASCADE,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS promocao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    validade DATE NOT NULL,
    tipo ENUM('Desconto', 'Frete', 'Produto') NOT NULL
);

CREATE TABLE IF NOT EXISTS acompanhamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao TEXT,
    valor DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS produto_acompanhamento (
    id_produto INT,
    id_acompanhamento INT,
    PRIMARY KEY(id_produto, id_acompanhamento),
    FOREIGN KEY (id_produto) REFERENCES produto(id) ON DELETE CASCADE,
    FOREIGN KEY (id_acompanhamento) REFERENCES acompanhamento(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS forma_pagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    forma VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS restaurante_pagamento (
    id_restaurante INT,
    id_forma_pagamento INT,
    PRIMARY KEY (id_restaurante, id_forma_pagamento),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id) ON DELETE CASCADE,
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS  pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_restaurante INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    taxa_entrega DECIMAL(10, 2) NOT NULL,
    id_promocao INT,
    id_forma_pagamento INT NOT NULL,
    observacoes TEXT,
    troco DECIMAL(10, 2),
    id_status_entrega INT NOT NULL,
    id_endereco INT NOT NULL,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id) ON DELETE CASCADE,
    FOREIGN KEY (id_promocao) REFERENCES promocao(id),
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id),
    FOREIGN KEY (id_status_entrega) REFERENCES status_entrega(id),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS historico_De_Pagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_Pagamento DATE,
    id_forma_pagamento INT,
    valor FLOAT,
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id)
);

CREATE TABLE IF NOT EXISTS status_entrega (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_entrega ENUM ('Preparando no Grey Sloan', 'Em rota pela Seattle Central', 'Entregue pelo Ambulância Express')
);

CREATE TABLE IF NOT EXISTS historico_De_Entregas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_status_entrega INT,
    id_pedido INT,
    data_hora DATETIME, 
    FOREIGN KEY (id_status_entrega) REFERENCES status_entrega(id),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

CREATE TABLE IF NOT EXISTS avaliacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota INT,
    id_pedido INT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

CREATE TABLE IF NOT EXISTS pedido_produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_produto) REFERENCES produto(id)
);

CREATE TABLE IF NOT EXISTS pedido_Produto_Acompanhamento (
    id_pedido_produto INT,
    id_acompanhamento INT,
    PRIMARY KEY (id_pedido_produto, id_acompanhamento),
    FOREIGN KEY (id_pedido_produto) REFERENCES pedido_produto(id),
    FOREIGN KEY (id_acompanhamento) REFERENCES acompanhamento(id)
);

INSERT INTO endereco (rua, bairro, numero, cidade, estado, ponto_referencia, complemento, cep, tipo_endereco) VALUES
('Rua Grey Sloan', 'Seattle Central', '123', 'Seattle', 'WA', 'Próximo ao hospital Grey Sloan', 'Apto 201', '98101-000', 'Residencial'),
('Avenida Shepherd', 'Capitol Hill', '456', 'Seattle', 'WA', 'Em frente ao Joe’s Bar', '', '98102-000', 'Comercial'),
('Rua Karev', 'Queen Anne', '78', 'Seattle', 'WA', 'Próximo ao Space Needle', '', '98103-000', 'Residencial'),
('Rua Bailey', 'First Hill', '89', 'Seattle', 'WA', 'Ao lado da clínica gratuita', 'Casa', '98104-000', 'Residencial'),
('Avenida Webber', 'Downtown', '102', 'Seattle', 'WA', '', 'Sala 205', '98105-000', 'Comercial')
ON DUPLICATE KEY UPDATE
bairro = VALUES(bairro),
numero = VALUES(numero),
ponto_referencia = VALUES(ponto_referencia),
complemento = VALUES(complemento),
tipo_endereco = VALUES(tipo_endereco);

INSERT INTO categoria (nome, descricao, tipo_categoria) VALUES
('Lanches', 'Lanches rápidos e saborosos', 'Alimentação'),
('Bebidas', 'Bebidas geladas e refrescantes', 'Bebida'),
('Sobremesas', 'Doces e sobremesas variadas', 'Sobremesa'),
('Massas', 'Pratos com massas italianas', 'Alimentação'),
('Petiscos', 'Opções de aperitivos', 'Alimentação')
ON DUPLICATE KEY UPDATE
descricao = VALUES(descricao),
tipo_categoria = VALUES(tipo_categoria);

INSERT INTO restaurante (nome, telefone, hora_funcionamento, is_retirada, id_categoria, valor_minimo_entrega, id_endereco_restaurante) VALUES
('Joe’s Diner', '12000000000', '10:00:00', TRUE, 1, 15.00, 1),
('Bar do Joe', '12011111111', '11:00:00', FALSE, 2, 10.00, 2),
('Restaurante Derek’s Pasta', '22222222222', '09:00:00', TRUE, 4, 20.00, 3),
('Confeitaria Lexie', '32333333333', '12:00:00', FALSE, 3, 5.00, 4),
('Snack Bailey', '42444444444', '16:00:00', TRUE, 5, 8.00, 5)
ON DUPLICATE KEY UPDATE
telefone = VALUES(telefone),
hora_funcionamento = VALUES(hora_funcionamento),
is_retirada = VALUES(is_retirada),
valor_minimo_entrega = VALUES(valor_minimo_entrega),
id_endereco_restaurante = VALUES(id_endereco_restaurante);

INSERT INTO produto (nome, preco, id_categoria, id_restaurante) VALUES
('Hambúrguer Sloan', 22.00, 1, 1),
('Milkshake de Bailey', 12.00, 2, 1),
('Pizza de Derek', 35.00, 4, 3),
('Torta de Lexie', 12.00, 3, 2),
('Café do Webber', 7.00, 2, 4)
ON DUPLICATE KEY UPDATE
preco = VALUES(preco),
id_categoria = VALUES(id_categoria),
id_restaurante = VALUES(id_restaurante);

INSERT INTO promocao (nome, codigo, valor, validade, tipo) VALUES
('Desconto Meredith 10%', 'MER10', 10.00, '2024-12-31', 'Desconto'),
('Frete Grátis Seattle', 'FRETESEA', 5.00, '2024-11-30', 'Frete'),
('Promo Torta Lexie', 'LEXIE5', 5.00, '2024-11-25', 'Produto'),
('Café Grátis Grey', 'GREYCAFE', 7.00, '2024-11-29', 'Produto'),
('Desconto Karev Verão', 'KAREV15', 15.00, '2025-01-31', 'Desconto')
ON DUPLICATE KEY UPDATE
valor = VALUES(valor),
validade = VALUES(validade),
tipo = VALUES(tipo);

INSERT INTO status_entrega (status_entrega)  
VALUES  
    ('Preparando no Grey Sloan'),  
    ('Em rota pela Seattle Central'),  
    ('Entregue pelo Ambulância Express')  
ON DUPLICATE KEY UPDATE  
    status_entrega = VALUES(status_entrega);


INSERT INTO pedido (data_Pedido, id_restaurante, valor, taxaEntrega, id_promocao, id_forma_pagamento, observacoes, troco, id_status_entrega, id_endereco) VALUES
('2024-12-01', 1, 55.00, 5.00, 1, 1, 'Sem cebola', 10.00, 1, 1),
('2024-12-02', 2, 20.00, 5.00, 2, 2, 'Entregar rápido', 0.00, 2, 2),
('2024-12-03', 3, 40.00, 10.00, NULL, 3, 'Sem picles', 0.00, 3, 3)
ON DUPLICATE KEY UPDATE
valor = VALUES(valor),
taxaEntrega = VALUES(taxaEntrega),
observacoes = VALUES(observacoes),
troco = VALUES(troco),
id_status_entrega = VALUES(id_status_entrega),
id_endereco = VALUES(id_endereco);

INSERT INTO pedido_produto (id_pedido, id_produto, quantidade) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1)
ON DUPLICATE KEY UPDATE
quantidade = VALUES(quantidade);

INSERT INTO pedido_produto_acompanhamento (id_pedido_produto, id_acompanhamento)
VALUES (1, 1), (1, 2), (2, 3) 
AS t
ON DUPLICATE KEY UPDATE id_acompanhamento = t.id_acompanhamento;
