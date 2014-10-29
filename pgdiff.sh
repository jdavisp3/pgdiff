#!/bin/bash
# pgdiff -U1 c42 -pw1 c422006 -d1 prd-cpc -o1 sslmode=disable -U2 c42 -pw2 c422006 -d2 cp_staging -o2 sslmode=disable COLUMN

USER1=c42
PASS1=c422006
HOST1=localhost
NAME1=prd-cpc
OPT1="sslmode=disable"

USER2=c42
PASS2=c422006
HOST2=localhost
NAME2=stg-cpc
OPT2="sslmode=disable"

function rundiff() {
    local TYPE=$1
    echo "Generating diff for $TYPE..."
    pgdiff -U1 $USER1 -pw1 $PASS1 -h1 $HOST1 -d1 $NAME1 -o1 "$OPT1" -U2 $USER2 -pw2 $PASS2 -h2 $HOST2 -d2 $NAME2 -o2 $OPT2 $TYPE > "${TYPE}.sql"
    echo -n "Press Enter to review the generated output: "; read x
    vi "${TYPE}.sql"
    echo -n "Do you wish to run this against ${NAME2}? [yN]: "; read x
    if [[ $x =~ y ]]; then
       pgrun -U $USER2 -pw $PASS2 -h $HOST2 -d $NAME2 -o $OPT2 -f "${TYPE}.sql"
    fi
}

rundiff SEQUENCE
rundiff TABLE
rundiff COLUMN
rundiff INDEX
#rundiff FOREIGN_KEY
#rundiff ROLE

