DROP TABLE IF EXISTS esser_expenditures;

CREATE TABLE esser_expenditures (
  unit TEXT,
  fund TEXT,
  account TEXT,
  program TEXT,
  grants TEXT,
  fiscal_year TEXT,
  amount NUMERIC,
  unit_name TEXT,
  fun_name TEXT,
  account_name TEXT,
  program_name TEXT,
  grant_name TEXT
);

.import "csv/esser_expenditures.csv" esser_expenditures --csv --skip 1

UPDATE esser_expenditures SET unit = 'U' || unit;
UPDATE esser_expenditures SET account = 'A' || account;
UPDATE esser_expenditures SET program = 'P' || program;

select * from esser_expenditures limit 10;