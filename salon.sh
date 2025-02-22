#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

# Create database and tables if they don't exist
$PSQL "CREATE DATABASE salon;" &> /dev/null
$PSQL "CREATE TABLE IF NOT EXISTS customers(
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL
);" &> /dev/null

$PSQL "CREATE TABLE IF NOT EXISTS services(
  service_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);" &> /dev/null

$PSQL "CREATE TABLE IF NOT EXISTS appointments(
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR NOT NULL
);" &> /dev/null

# Insert initial services if they don't exist
$PSQL "INSERT INTO services(name) SELECT 'Hair Cut' WHERE NOT EXISTS (SELECT 1 FROM services WHERE service_id=1);
      "INSERT INTO services(name) SELECT 'Coloring' WHERE NOT EXISTS (SELCET 1 FROM services WHERE service_id=2);
      "INSERT INTO services(name) SELECT 'Styling' WHERE NOT EXISTS (SELECT 1 FROM services WHERE service_id=3);" &> /dev/null

main_menu() {
  # Show services
  echo -e "\n~~~~~ MY SALON ~~~~~"
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  # Get service selection
  read -p "> " SERVICE_ID_SELECTED

  # Validate service
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_is=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    main_menu
    return
  fi

  # Get customer info
  read -p "Enter your phone number: " CUSTOMER _PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # New customer
  if [[ -z $CUSTOMER_ID ]]
  then
    read -p "Enter your name: " CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    fi

    # Get appointment time
    read -p "Enter appointment time: " SERVICE_TIME

    # Insert appintment
    INSERT_APPOINTMNET=$($PSQL "INSERT INTO appointments(Customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    # Output confirmation
    echo "I have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ +| +$//g') at $(echo $SERVICE_TIME | sed -E 's/^ +| +$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ +| +$//g')."

    # Start program
    main_menu
