#!bin/bash

pregunta1="1.-Suma 2.-Resta 3.-Multiplicación"
pregunta2="Primer número?"
pregunta3="Segundo número?"
resultado=0
opcion=-1

echo "$pregunta1"
read opcion

echo "$pregunta2"
read num1

echo "$pregunta3"
read num2

if [ $pregunta1 -eq 1]
then
	resultado = $((pregunta1 + pregunta2))
	echo "$resultado"
fi
