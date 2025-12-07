#!bin/bash

#############################################
##  Create Manager Sctructure
#############################################
mkdir "config" "lib" "modules" "logs" "backups"

#############################################
## Create Archives
#############################################

## Create main.sh script
cat > main.sh << "MAIN_CONTENT"

    contenido de los archivos

MAIN_CONTENT