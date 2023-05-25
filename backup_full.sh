# Funcion para generar el log
generate_log() {
  timestamp=$(date +"%H:%M:%S")
  echo "$timestamp - $1" >> /u03/logs_backups/backup.log
}

# Funcion para enviar el log por mail al usuario root
# El dominio creado en el servidor SMTP es "grupo5.up", y hay que enviarlo al usuario root (root@grupo5.up)
send_log_email() { 
  mutt -s "Log de ejecucion del script de backup" root@grupo5.up  < /u03/logs_backups/backup.log
}

# Crea el comando '-h' para la terminal
while getopts "h" opt; do
  case ${opt} in
    h)
      generate_log "Mostrando ayuda"
      show_help
      exit 0
      ;;
    \?)
      echo "Opcion invalida: -$OPTARG" >&2
      generate_log "Opcion invalida: -$OPTARG"
      exit 1
      ;;
  esac
done

# Verifica si el filesystem de origen /etc existe y esta montado
if [ ! -d "/etc" ] || ! mountpoint -q "/etc"; then
  generate_log "El filesystem de origen /etc no esta disponible."
  exit 1
fi

# Verifica si el filesystem de origen /var/logs existe y esta montado
if [ ! -d "/var/logs" ] || ! mountpoint -q "/var/logs"; then
  generate_log "El filesystem de origen /var/logs no esta disponible."
  exit 1
fi

# Verifica si es domingo ('0' representa domingo en bash)
if [ $(date +%w) -eq 0 ]; then
  # Verifica si el filesystem de origen /u01 existe y esta montado
  if [ ! -d "/u01" ] || ! mountpoint -q "/u01"; then
    generate_log "El filesystem de origen /u01 no esta disponible."
    exit 1
  fi

  # Verifica si el filesystem de origen /u02 existe y esta montado
  if [ ! -d "/u02" ] || ! mountpoint -q "/u02"; then
    generate_log "El filesystem de origen /u02 no esta disponible."
    exit 1
  fi
fi

# Obtenemos la fecha en formato ANSI (YYYYMMDD)
date=$(date +%Y%m%d)

# Realiza el backup de /etc y /var/logs todos los dias a las 0 hs
generate_log "Realizando backup de /etc y /var/logs"
tar -czf "/u03/etc_bkp_$date.tar.gz" /etc
tar -czf "/u03/var_logs_bkp_$date.tar.gz" /var/logs

# Verifica si hoy es domingo ('0' representa domingo en bash)
if [ $(date +%w) -eq 0 ]; then
  # Realiza el backup de /u01 y /u02 los domingos a las 23 hs
  generate_log "Realizando backup de /u01 y /u02"
  tar -czf "/u03/u01_bkp_$date.tar.gz" /u01
  tar -czf "/u03/u02_bkp_$date.tar.gz" /u02
fi

# Enviar el log por mail al usuario root
send_log_email
