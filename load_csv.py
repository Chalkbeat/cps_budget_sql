import sqlite3
import csv

db = sqlite3.connect("budget.db")

print("Setting up table...")

db.executescript("""

DROP TABLE IF EXISTS budget_book;

CREATE TABLE budget_book (
  fiscal_year TEXT,
  unit TEXT,
  unit_name TEXT,
  fund TEXT,
  fund_name TEXT,
  account TEXT,
  account_name TEXT,
  program TEXT,
  program_name TEXT,
  last_adopted_budget NUMERIC,
  last_ending_budget NUMERIC,
  last_projected_expenditures NUMERIC,
  proposed_budget NUMERIC,
  last_budgeted_positions NUMERIC,
  last_ending_positions NUMERIC,
  proposed_positions NUMERIC
);
""")

insert_statement = "INSERT INTO budget_book VALUES (%s)" % ", ".join(["?" for x in range(16)])

for y in range(21, 26):
  file_name = "csv/FY%s.csv" % y
  with open(file_name) as input_file:
    print("Loading file " + file_name)
    reader = csv.reader(input_file)
    # skip first line
    next(reader)
    for row in reader:
      row = [cell.strip() for cell in row]
      row.insert(0, y + 2000)
      db.execute(insert_statement, row)
    db.commit()