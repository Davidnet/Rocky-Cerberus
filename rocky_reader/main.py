#!/usr/bin/env python

import sys
import subprocess as sp
import os

import typer


def main(db_filepath: str):
    # Dump the schema for the DB
    sp.call(["mdb-schema", db_filepath, "mysql"])

    # Get the list of table names with "mdb-tables"
    table_names = sp.Popen(
        ["mdb-tables", "-1", db_filepath], stdout=sp.PIPE
    ).communicate()[0]

    tables = table_names.splitlines()
    print("BEGIN;")
    sys.stdout.flush()

    for table in tables:
        if table != "":
            sp.call(["mdb-export", "-I", "mysql", db_filepath, table])

    print("COMMIT;")  # End transaction
    sys.stdout.flush()


if __name__ == "__main__":
    typer.run(main)
