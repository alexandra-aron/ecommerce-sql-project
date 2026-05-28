# Ecommerce SQL Project

## Overview
Acesta este un proiect de bază de date pentru un sistem simplu de e-commerce.

Am construit acest proiect pentru a exersa design-ul unei baze de date relaționale și SQL (JOIN-uri, indexuri, constrângeri, agregări și view-uri).

---

## Database structure

Proiectul conține următoarele tabele:

- **categorie** – categorii de produse  
- **utilizator** – utilizatori ai platformei  
- **produs** – lista de produse disponibile  
- **comanda** – comenzile plasate de utilizatori  
- **produse_comandate** – legătura dintre comenzi și produse  

---

## Relații între tabele

- un utilizator poate avea mai multe comenzi  
- o comandă aparține unui singur utilizator  
- un produs aparține unei categorii  
- o comandă poate conține mai multe produse  
- un produs poate apărea în mai multe comenzi  

---

## Ce am implementat în proiect

- primary keys și foreign keys  
- constrângeri (NOT NULL, UNIQUE, CHECK)  
- indexuri pentru performanță  
- JOIN-uri între tabele  
- subquery-uri  
- funcții de agregare (SUM, AVG)  
- materialized view pentru raportare  

---

## Exemple de query-uri SQL

### 1. Join între utilizatori și comenzi

```sql
SELECT u.nume_utilizator,
       co.pret_total,
       co.status
FROM utilizator u
JOIN comanda co
    ON u.id_utilizator = co.id_utilizator;
