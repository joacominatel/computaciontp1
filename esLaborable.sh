#!/bin/bash

# Funcion para determinar si una fecha es un dia no laborable
esLaborable() {
  local fecha=$1
  local dia=$(date -d "$fecha" +%d)
  local mes=$(date -d "$fecha" +%m)
  local anual=$(date -d "$fecha" +%Y)

  # Verifica dias no laborables segun la ley
  case $mes-$dia in
    01-01)
      echo "El $dia de enero de $anual es un día no laborable (Año Nuevo)."
      ;;
    *)
      # Verifica dias no laborables moviles segun la ley
      case $mes-$dia in
        $(date -d "31st March $anual" +%m-%d) | $(date -d "1st April $anual" +%m-%d) | \
        $(date -d "24th March $anual" +%m-%d) | $(date -d "2nd April $anual" +%m-%d) | \
        $(date -d "10th April $anual" +%m-%d) | $(date -d "1st May $anual" +%m-%d) | \
        $(date -d "25th May $anual" +%m-%d) | $(date -d "20th June $anual" +%m-%d) | \
        $(date -d "9th July $anual" +%m-%d) | $(date -d "17th August $anual" +%m-%d) | \
        $(date -d "12th October $anual" +%m-%d) | $(date -d "20th November $anual" +%m-%d) | \
        $(date -d "8th December $anual" +%m-%d) | $(date -d "25th December $anual" +%m-%d))
          echo "El $dia de $mes de $anual es un día no laborable según la ley."
          ;;
        *)
          echo "El $dia de $mes de $anual es un día laborable."
          ;;
      esac
      ;;
  esac
}
