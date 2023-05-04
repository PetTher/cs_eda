#!/bin/bash

echo "Login attempt..."
snowsql -c $1 -m $2 -f ./preparation_test.sql
echo "Done."