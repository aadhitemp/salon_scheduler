#!/bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~"
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
MAIN_MENU(){
  echo -e "\n$1"
  echo -e "1) Cut\n2) Color\n3) Perm\n4) Style\n5) Trim"
    
  read SERVICE_ID_SELECTED

#getting customer phone number
if [[ ! $SERVICE_ID_SELECTED =~ [1-5] ]]
then
  MAIN_MENU "I could not find that service. What would you like today?"
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

#getting customer ID and customer name
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id= $SERVICE_ID_SELECTED")
echo $SERVICE_NAME
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


fi
}

MAIN_MENU "Welcome to My Salon, how can I help you?\n"