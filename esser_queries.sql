.open "budget.db"

.mode csv
.echo off
.headers on

.print "Running report: ESSER budget totals by unit"

.once "output/esser_by_unit_and_year.csv"

SELECT 
  (everything.fiscal_year - 1) as fiscal_year,
  everything.unit,
  everything.unit_name,
  total,
  esser,
  esser / total AS percentage
FROM (
  SELECT 
    fiscal_year,
    unit,
    unit_name,
    sum(last_ending_budget) AS total
  FROM budget_book
  GROUP BY fiscal_year, unit
  ORDER BY fiscal_year DESC, total DESC
) AS everything
LEFT JOIN (
  SELECT
    fiscal_year,
    unit,
    unit_name,
    IFNULL(SUM(last_ending_budget), 0.0) AS esser
  FROM budget_book
  WHERE fund LIKE "FG370%"
  GROUP BY fiscal_year, unit
) AS covid
ON 
  covid.fiscal_year = everything.fiscal_year AND
  covid.unit = everything.unit;

.once "output/esser_by_unit.csv"

SELECT 
  everything.unit,
  everything.unit_name,
  total,
  esser,
  esser / total AS percentage
FROM (
  SELECT 
    unit,
    unit_name,
    sum(last_ending_budget) AS total
  FROM budget_book
  GROUP BY unit
  ORDER BY total DESC
) AS everything
LEFT JOIN (
  SELECT
    unit,
    unit_name,
    IFNULL(SUM(last_ending_budget), 0.0) AS esser
  FROM budget_book
  WHERE fund LIKE "FG370%"
  GROUP BY unit
) AS covid
ON 
  covid.unit = everything.unit;

.print "Running report: ESSER totals by account/program"

.once "output/esser_by_program_and_year.csv"

SELECT 
  (fiscal_year - 1) as fiscal_year,
  account,
  account_name,
  program,
  program_name,
  total,
  esser,
  esser / total AS percentage
FROM (
  SELECT
    fiscal_year,
    account,
    account_name,
    program,
    program_name,
    sum(last_ending_budget) AS total
  FROM budget_book
  GROUP BY fiscal_year, account, program
  ORDER BY fiscal_year DESC, total DESC
) AS everything
LEFT JOIN (
  SELECT
    fiscal_year AS cfy,
    account AS ca,
    program AS cp,
    IFNULL(SUM(last_ending_budget), 0.0) AS esser
  FROM budget_book
  WHERE fund LIKE "FG370%"
  GROUP BY fiscal_year, account, program
) AS covid
ON 
  cfy = fiscal_year AND
  ca = account AND
  cp = program;


.once "output/esser_by_program.csv"

SELECT 
  account,
  account_name,
  program,
  program_name,
  total,
  esser,
  esser / total AS percentage
FROM (
  SELECT
    account,
    account_name,
    program,
    program_name,
    sum(last_ending_budget) AS total
  FROM budget_book
  GROUP BY account, program
  ORDER BY total DESC
) AS everything
LEFT JOIN (
  SELECT
    account AS ca,
    program AS cp,
    IFNULL(SUM(last_ending_budget), 0.0) AS esser
  FROM budget_book
  WHERE fund LIKE "FG370%"
  GROUP BY account, program
) AS covid
ON
  ca = account AND
  cp = program;

.once "output/esser_by_program_and_unit_prefix.csv"

SELECT 
  account,
  account_name,
  program,
  program_name,
  prefix,
  total,
  esser,
  esser / total AS percentage
FROM (
  SELECT
    account,
    account_name,
    program,
    program_name,
    substring(unit, 0, 3) as prefix,
    sum(last_ending_budget) AS total
  FROM budget_book
  GROUP BY account, program, prefix
  ORDER BY total DESC
) AS everything
LEFT JOIN (
  SELECT
    account AS ca,
    program AS cp,
    substring(unit, 0, 3) as cu,
    IFNULL(SUM(last_ending_budget), 0.0) AS esser
  FROM budget_book
  WHERE fund LIKE "FG370%"
  GROUP BY ca, cp, cu
) AS covid
ON
  ca = account AND
  cp = program AND
  cu = prefix;