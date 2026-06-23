#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then

#test if input is number
numtest='^[0-9]+$'
if [[ $1 =~ $numtest ]];
then
#number lookup
INITIAL_LOOKUP_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types on properties.type_id=types.type_id WHERE elements.atomic_number=$1")
else
#nonnumber lookup
INITIAL_LOOKUP_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types on properties.type_id=types.type_id WHERE name='$1' OR symbol='$1'")
fi

#test for presence of input in database
if ! [[ -z $INITIAL_LOOKUP_RESULT ]]
then
#if valid, return information
echo -e "$INITIAL_LOOKUP_RESULT" | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
do
echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
else
#if invalid, return error
echo -e "I could not find that element in the database."
fi

else
echo -e "Please provide an element as an argument."
fi
