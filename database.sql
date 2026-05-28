-- tabel categorii
CREATE TABLE categorie(
    id_categorie BIGSERIAL,
    nume_categorie VARCHAR(100),

    CONSTRAINT categorie_pk
        PRIMARY KEY(id_categorie)
);


-- tabel utilizatori
CREATE TABLE utilizator(
    id_utilizator BIGSERIAL,
    nume_utilizator VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    parola VARCHAR(300) NOT NULL,
    data_creata TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT utilizator_pk
        PRIMARY KEY(id_utilizator)
);


-- tabel produse
CREATE TABLE produs(
    id_produs BIGSERIAL,
    nume_produs VARCHAR(100) NOT NULL,
    pret NUMERIC(10,2) NOT NULL CHECK(pret > 0),
    stoc BIGINT NOT NULL CHECK(stoc >= 0),
    categorie_id BIGINT NOT NULL,

    CONSTRAINT produs_pk
        PRIMARY KEY(id_produs),

    CONSTRAINT produs_fk
        FOREIGN KEY(categorie_id)
        REFERENCES categorie(id_categorie)
);


-- index pentru filtrare dupa categorie
CREATE INDEX idx_produs_categorie
ON produs(categorie_id);


-- index pentru sortare dupa pret
CREATE INDEX idx_produs_pret
ON produs(pret);


-- tabel comenzi
CREATE TABLE comanda(
    id_comanda BIGSERIAL,
    id_utilizator BIGINT NOT NULL,
    pret_total NUMERIC(10,2) NOT NULL CHECK(pret_total >= 0),
    status VARCHAR(20) NOT NULL CHECK(
        status IN ('in procesare', 'finalizata', 'anulata')
    ),
    data_creare TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT comanda_pk
        PRIMARY KEY(id_comanda),

    CONSTRAINT comanda_fk
        FOREIGN KEY(id_utilizator)
        REFERENCES utilizator(id_utilizator)
);


-- tabel produse din comenzi
CREATE TABLE produse_comandate(
    id_produse_comandate BIGSERIAL,
    id_comanda BIGINT NOT NULL,
    id_produs BIGINT NOT NULL,
    cantitate BIGINT NOT NULL CHECK(cantitate > 0),
    pret NUMERIC(10,2) NOT NULL CHECK(pret > 0),

    CONSTRAINT produse_comandate_pk
        PRIMARY KEY(id_produse_comandate),

    CONSTRAINT produse_comandate_fk_1
        FOREIGN KEY(id_comanda)
        REFERENCES comanda(id_comanda),

    CONSTRAINT produse_comandate_fk_2
        FOREIGN KEY(id_produs)
        REFERENCES produs(id_produs)
);


-- date test categorii
INSERT INTO categorie(id_categorie, nume_categorie)
VALUES
(1, 'Carti'),
(2, 'Rechizite'),
(3, 'Jucarii'),
(4, 'Cadouri'),
(5, 'Electronice');


-- exemplu join simplu intre utilizatori si comenzi
SELECT
    u.nume_utilizator,
    co.pret_total,
    co.status
FROM utilizator u
JOIN comanda co
    ON u.id_utilizator = co.id_utilizator;


-- total cheltuit per utilizator
SELECT
    u.nume_utilizator,
    SUM(co.pret_total) AS total_cheltuit
FROM utilizator u
JOIN comanda co
    ON u.id_utilizator = co.id_utilizator
GROUP BY u.nume_utilizator
ORDER BY total_cheltuit DESC;


-- produse peste media de pret
SELECT
    nume_produs,
    pret
FROM produs
WHERE pret > (
    SELECT AVG(pret)
    FROM produs
);


-- total vanzari per categorie pentru raportare si analiza business
CREATE MATERIALIZED VIEW mv_vanzari_categorie AS
SELECT
    cat.nume_categorie,
    SUM(pc.cantitate * pc.pret) AS total_vanzari
FROM produse_comandate pc
JOIN produs p
    ON pc.id_produs = p.id_produs
JOIN categorie cat
    ON p.categorie_id = cat.id_categorie
GROUP BY cat.nume_categorie;


-- refresh materialized view dupa update-uri
REFRESH MATERIALIZED VIEW mv_vanzari_categorie;


-- verificare index pe categorie
EXPLAIN ANALYZE
SELECT *
FROM produs
WHERE categorie_id = 3;
