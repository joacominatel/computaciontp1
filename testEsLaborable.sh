# Incluir el archivo que contiene la función esLaborable()
source /opt/tp/scripts/esLaborable.sh

# Obtener la fecha actual
fecha_actual=$(date +%Y-%m-%d)

# Invocar la función esLaborable() con la fecha actual
esLaborable "$fecha_actual"