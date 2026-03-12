#! /bin/bash

# Tenéis que sustituir la línea: # AQUÍ TU COMANDO (elimina el comentario)

# Los ejercicios se resuelven sólo con una línea.
# La salida estándar de cada ejercicio debe derivarse a un fichero de la forma: 
# <número de una o más cifras>.txt

# Debéis entregar sólo el fichero Ejercicio_Textos_VUESTRASINICIALES.sh
# Para la corrección lo ejecutaré y cotejaré los distintos ficheros .txt que generará 
# vuestro script.

# Ejemplo:
# 0. Muestra numerando las líneas el fichero sources.list
# Eliminamos # AQUÍ TU COMANDO y escribimos la orden, seguida del vuelco de la salida estándar
# a 0,txt, ya que estamos en la pregunta 0.
cat -n "texto/sources.list" > 0.txt

# En el contexto de este ejercicio definimos palabra como una cadena alfanumérica 
# sin espacios ni signos de puntuación.

# Detalle de los archivos suministrados con la práctica:
# texto/bashrc es un fichero de ejemplo de ~/.bashrc
# texto/passwd es un fichero de ejemplo de /etc/passwd
# texto/syslog es un fichero de ejemplo de /var/log/syslog
# texto/sources.list es un fichero de ejemplo de /etc/apt/sources.list
# texto/quijote-es.txt es un versión en texto plano de D.Miguel de Cervantes Saavedra

# 1. Muestra las tres últimas líneas del fichero passwd:
tail -n 3 "texto/passwd" > 1.txt


# 2. Muestra por pantalla los caracteres 1,3,4,5,6 de passwd:
cut -c 1,3-6 "texto/passwd" > 2.txt


# 3. Muestra los tres primeros usuarios en passwd.
# Fíjate en que los nombres de usuario son el primer campo separado por el carácter :
head -n 3 "texto/passwd" | cut -d : -f1 > 3.txt


# 4. Selecciona las horas minutos y segundos, apareciendo los ':' entre ellos, 
# de todas las entradas de syslog:
cut -d " " -f 3 "texto/syslog" | cut -d " " -f3 > 4.txt


# 5. Tras seleccionar las horas minutos y segundos de todas las entradas de syslog,
# quédate sólo con las horas y minutos. Deben aparecer los dos puntos entre hora y minutos.
cut -d " " -f 3 "texto/syslog" | cut -d " " -f3 | cut -d ":" -f 1,2 > 5.txt


# 6. Cuenta en el quijote-es.txt el número de palabras.
wc -w "texto/quijote-es.txt" > 6.txt


# 7. Cuenta en el quijote-es.txt el número de líneas.
wc -l "texto/quijote-es.txt" > 7.txt


# 8. Cuenta en el quijote-es.txt el número de caracteres.
wc -m "texto/quijote-es.txt" > 8.txt


# 9. Cuenta el número de líneas en las que aparece Sancho en El Quijote.
grep -c "Sancho" "texto/quijote-es.txt" > 9.txt


# 10. Imprime por pantalla las tres primeras líneas de El Quijote donde aparezca 
# la palabra Sancho y numéralas al principio.
grep -m 3 "Sancho" "texto/quijote-es.txt" | cat -n > 10.txt


# 11. Muestra, indicando el número de línea del texto original, las tres últimas 
# líneas en las que Sancho aparece en El Quijote.
cat -n "texto/quijote-es.txt" | grep "Sancho" | tail -n 3 > 11.txt


# 12. Nos han comentado que en la línea 15 de ~/.bashrc se ha producido un error.
# Mostrad las líneas que van de la 10 a la 19, a fin de apreciar una instantánea del error.
sed -n '10,19p' "texto/bashrc" > 12.txt


# 13. Ahora que sabes cómo seleccionar las horas minutos y segundos de todas 
# las entradas de syslog, muestra cuántas entradas por hora se han introducido en syslog.
cut -d " " -f 3 "texto/syslog" | cut -d ":" -f 1 | uniq -c > 13.txt


# 14. Buscad en El Quijote las diez últimas líneas donde aparezcan la palabra molinos y mostradlas.
grep "molinos" "texto/quijote-es.txt" | tail -n 10 > 14.txt


# 15. A continuación, en las diez últimas líneas, sustituid la palabra molinos por GIGANTES.
grep "molinos" "texto/quijote-es.txt" | tail -n 10 | sed 's/molinos/GIGANTES/g' > 15.txt


# 16. El fichero de configuración /etc/apt/sources.list contiene la configuración 
# de los repositorios de paquetes Debian.
# El problema es que hay demasiadas líneas con comentarios.
# Queremos ver el contenido del fichero sources.list sin las líneas que comienzan con comentarios.
grep "^[^#]" "texto/sources.list" > 16.txt #|| grep -v "#" "texto/sources.list" > 16.txt

# Dentro de sources.list las líneas que comienzan con "deb" definen un repositorio de 
# paquetes debian, el formato de empaquetamiento de aplicaciones adoptado en Debian y Ubuntu
# En estas líneas que definen repositorios tenemos paquetes debian mantenidos por Canonical
# en las secciones main, con software libre, y restricted, con software no libre. 
# En las líneas de repositorios que son mantenidos por la comunidad están
# las secciones universe, con software libre, y multiverse, con software no libre. 


# 17. Muestra, sin repetir, la líneas de repositorio de software libre mantenidas por Canonical 
# sin comentar (sin el carácter # al inicio de línea). Estas líneas comienzan con la palabra deb.
grep "^[^#]" "texto/sources.list" | grep "^deb.*" "texto/sources.list" | grep "main" > 17.txt


# 18. ¿Cuántas líneas de software no libre mantenida por la comunidad hay definidas en sources.list?
grep "^[^#]" "texto/sources.list" | grep -c "universe" > 18.txt


# 19. Muestra las tres primeras líneas del sources.list
head -n 3 "texto/sources.list" > 19.txt


# 20. De las tres primeras líneas de sources.list, deja sólo un elemento, sin espacios.
# Pista: sustituye los espacios por un retorno de carro, con \n.
head -n 3 "texto/sources.list" | sed 's| |\n|g' > 20.txt


# 21. Considera sólo las tres primeras líneas de sources.list. De los términos sin espacios quédate
# sólo con los términos que empiezan y acaban por alfanúmérico, sin espacios ni signos 
# de puntuación, con al menos un carácter. 
head -n 3 "texto/sources.list" | sed 's/ /\n/g' | grep "^[[:alnum:]]\+$" > 21.txt


# Observarás que en el apartado 21 algunos términos se repiten. 
# Si quisiéramos quedarnos sólo con los términos no repetidos, tendremos que valernos del comando
# uniq
# , sin embargo este comando sólo tiene una fuerte restricción: sólonos agrupará términos contiguos.
# 22. Ordena las palabras, subcadenas alfanuméricas, de las tres primeras líneas del 
# fichero sources.list.
head -n 3 "texto/sources.list" | sed 's| |\n|g' | grep "^[[:alnum:]]\+$" | sort > 22.txt


# Ahora lo tenemos todo preparado para aplicar uniq. 
# Recuerda que por defecto distingue entre mayúsculas y minúsculas.
# 23. Muestra las palabras, sin repetir ninguna, de las tres primeras líneas del 
# fichero sources.list.
head -n 3 "texto/sources.list" | sed 's| |\n|g' | grep "^[[:alnum:]]\+$" | sort | uniq > 23.txt


# uniq no sólo nos permite quedarnos con la única ocurrencia de varias palabras contiguas, 
# también nos permite conocer el número de veces que sucedieron estas ocurrencias.
# 24. Muestra las palabras, sin repetir ninguna, del fichero sources.list, 
# indicando además al inicio de cada línea el número de ocurrencias.
cat "texto/sources.list" | sed 's| |\n|g' | grep "^[[:alnum:]]\+$" | sort | uniq -c > 24.txt


# En este ejercicio haremos un segundo sort con el parámetro que invierte el orden
# de menor a mayor, para mostrar todo de mayor a menor.
# 25. Muestra las palabras, sin repetir ninguna, del fichero sources.list, 
# indicando además al inicio de cada línea el número de ocurrencias,
# pero ahora ordénalas de mayor a menor con un nuevo sort.
cat "texto/sources.list" | sed 's| |\n|g' | grep "^[[:alnum:]]\+$" | sort | uniq -c | sort -rn > 25.txt


# Este ejercicio será como el anterior pero quedándonos al final con los diez términos
# con mayor ocurrencia.
# 26. Muestra las palabras, sin repetir ninguna, del fichero sources.list, 
# indicando además al inicio de cada línea el número de ocurrencias,
# pero ahora ordénalas de mayor a menor con un nuevo sort.
cat "texto/sources.list" | sed 's| |\n|g' | grep "^[[:alnum:]]\+$" | sort | uniq -c | sort -rn | head -n 10 > 26.txt


# 27. Ya estamos preparados para un reto mayor.
# Vamos a separar las palabras de El Quijote en una por línea.
# Nos vamos a quedar sólo con las que tengan a partir de 6 caracteres.
sed 's| |\n|g' "texto/quijote-es.txt" | grep "^[[:alpha:]]\{6,\}$" > 27.txt


# 28. Ordena las palabras de más de 6 caracteres de El Quijote.
sed 's| |\n|g' "texto/quijote-es.txt" | grep "^[[:alpha:]]\{6,\}$" | sort > 28.txt


# 29. A partir de las palabras ordenadas de más de 6 caracteres de El Quijote,
# sin importar mayúsculas, unifica la palabras iguales con uniq, mostrando el número de ocurrencias.
sed 's| |\n|g' "texto/quijote-es.txt" | grep "^[[:alpha:]]\{6,\}$" | sort -f | uniq -ic > 29.txt



# 30. A partir de las palabras ordenadas de más de 6 caracteres de El Quijote,
# unificadas sin importar mayúsculas y antecedidas de su número de ocurrencia,
# muestra por pantalla las seis palabras de seis o más letras de El Quijote con mayor 
# número de ocurrencia, ordenadas por ocurrencia de mayor a menor.
sed 's| |\n|g' "texto/quijote-es.txt" | grep "^[[:alpha:]]\{6,\}$" | sort -f | uniq -ic | sort -nr | head -n 6 > 30.txt