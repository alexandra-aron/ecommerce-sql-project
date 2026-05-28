# Ecommerce SQL Project

## Overview

Acest proiect a fost construit pentru a exersa modelarea unei baze de date relaționale și scrierea de interogări SQL. Include relații între tabele, constrângeri, indexuri și query-uri de analiză.

---

## Database Structure

Baza de date conține următoarele tabele:

- **categorie** – categorii de produse
- **utilizator** – utilizatori ai platformei
- **produs** – produse disponibile
- **comanda** – comenzile plasate de utilizatori
- **produse_comandate** – articolele din fiecare comandă (order items)

---

## ERD (Entity Relationship Diagram)

UTILIZATOR (1) ─────── (N) COMANDA  
- utilizator.id_utilizator (PK)  
- comanda.id_utilizator (FK)

COMANDA (1) ─────── (N) PRODUSE_COMANDATE  
- comanda.id_comanda (PK)  
- produse_comandate.id_comanda (FK)

PRODUS (1) ─────── (N) PRODUSE_COMANDATE  
- produs.id_produs (PK)  
- produse_comandate.id_produs (FK)

CATEGORIE (1) ─────── (N) PRODUS  
- categorie.id_categorie (PK)  
- produs.categorie_id (FK)
CATEGORIE (1) ─────── (N) PRODUS  
- categorie.id_categorie (PK)  
- produs.categorie_id (FK)
