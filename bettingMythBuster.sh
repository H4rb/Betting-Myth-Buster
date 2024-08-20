#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Funcion para vincular el ctrl+c
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm; exit 1
}

# CTRL+C
trap ctrl_c INT

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Funciones
function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money$ ${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  par_impar="$(echo $par_impar | tr '[:upper:]' '[:lower:]')"
  
  if [[ "$initial_bet" =~ ^[0-9]+$ ]]; then
    if [ "$par_impar" == "par" ]; then
      echo -e "\n${blueColour}[*]${endColour}${grayColour} Vamos a jugar con la cantidad inicial de${endColour}${yellowColour} $initial_bet$ ${endColour}${grayColour}a${endColour}${yellowColour} $par_impar${endColour}\n"
    elif [ "$par_impar" == "impar" ]; then
      echo -e "\n${blueColour}[*]${endColour}${grayColour} Vamos a jugar con la cantidad inicial de${endColour}${yellowColour} $initial_bet$ ${endColour}${grayColour}a${endColour}${yellowColour} $par_impar${endColour}\n"
    else
      echo -e "\n${redColour}[!] Solo puedes apostar a par o impar!${endColour}"
      exit 1
    fi

    #echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con la cantidad inicial de${endColour}${yellowColour} $initial_bet$ ${endColour}${grayColour}a${endColour}${yellowColour} $par_impar${endColour}\n"

    backup_initial_bet=$initial_bet
    declare -i play_counter=0
    max_money=$money
    loss_plays=()

    while true; do
      tput civis

      random_number=$(($RANDOM % 37))
      money=$(($money-$initial_bet))

      if [ $money -gt 0 ]; then
        echo -e "${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${yellowColour} $initial_bet$ ${endColour}${grayColour}y ahora tienes${endColour}${yellowColour} $money$ ${endColour}"
        if [ "$par_impar" == "par" ]; then       
          if [ $(($random_number % 2)) -eq 0 ]; then
            if [ $random_number -eq 0 ]; then
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}${grayColour} por lo tanto no es par ni impar,${endColour}${redColour} PERDISTE!${endColour}"
              initial_bet=$(($initial_bet*2))
              loss_plays="$random_number "
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo tu capital queda en${endColour}${yellowColour} $money$ ${endColour}\n"
            else
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endolour}${grayColour} por lo tanto es par,${endColour}${greenColour} GANASTE!${endColour}"
              reward=$(($initial_bet*2))
              let money+=$reward
              initial_bet=$backup_initial_bet
              let max_money+=$initial_bet
              loss_plays=()
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo tu capital queda en${endColour}${yellowColour} $money$ ${endColour}\n"
            fi
          else
            echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}${grayColour} por lo tanto es impar,${endColour}${redColour} PERDISTE!${endColour}"
            initial_bet=$(($initial_bet*2))
            loss_plays+="$random_number "
            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo tu capital queda en${endColour}${yellowColour} $money$ ${endColour}\n"
          fi

      #sleep 2

        elif [ "$par_impar" == "impar" ]; then
          if [ $(($random_number % 2)) -eq 1 ]; then
            if [ $random_number -eq 0 ]; then
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}${grayColour} por lo tanto no es par ni impar,${endColour}${redColour} PERDISTE!${endColour}"
              initial_bet=$(($initial_bet*2))
              loss_plays="$random_number "
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo tu capital queda en${endColour}${yellowColour} $money$ ${endColour}\n"
            else
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endolour}${grayColour} por lo tanto es impar,${endColour}${greenColour} GANASTE!${endColour}"
              reward=$(($initial_bet*2))
              let money+=$reward
              initial_bet=$backup_initial_bet
              let max_money+=$initial_bet
              loss_plays=()
              echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo tu capital queda en${endColour}${yellowColour} $money$ ${endColour}\n"
            fi
          else
            echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}${grayColour} por lo tanto es par,${endColour}${redColour} PERDISTE!${endColour}"
            initial_bet=$(($initial_bet*2))
            loss_plays+="$random_number "
            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo tu capital queda en${endColour}${yellowColour} $money$ ${endColour}\n"
          fi

      #sleep 2

        else
          echo -e "\n${redColour}[!] Solo puedes apostar a par o impar!${endColour}"
          break
        fi
      else
        echo -e "\n${redColour}[!] No tienes suficiente capital para continuar el Martingala, ahora mismo necesitarias apostar${endColour}${yellowColour} $initial_bet$ ${endColour}${redColour}y tu capital quedaria en${endColour}${purpleColour} $money$ ${endColour}${redColour}NO PUEDES SEGUIR!${endColour}"
        echo -e "\n\n\t${yellowColour}[!]${endColour}${blueColour} Estadisticas:${endColour}\n"
        echo -e "\t${yellowColour}[+]${endColour}${grayColour} La ganacia maxima ha sido de${endColour}${greenColour} $max_money$ ${endColour}"
        echo -e "\t${yellowColour}[+]${endColour}${grayColour} Ha/Han habido${endColour}${blueColour} $play_counter${endColour}${grayColour} jugadas en total${endColour}"
        echo -e "\t${yellowColour}[+]${endColour}${grayColour} A continuacion se van a representar las malas jugadas consecutivas antes de quebrar:${endColour}${redColour} [ $loss_plays]${endColour}"
        echo -e "\t${yellowColour}[+]${endColour}${grayColour} La cantidad de perdidas consecutivas fue de${endColour}${redColour} $(echo $loss_plays | wc -w)${endColour}"
        exit 0
      fi
      let play_counter+=1
    done
  else
    echo -e "\n${redColour}[!] El valor de la apuesta inicial debe ser numerico! Intenta de nuevo!${endColour}"
  fi
    tput cnorm
}

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function inverselabrouchere(){

  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  # Primera validacion para comenzar
  par_impar="$(echo $par_impar | tr '[:upper:]' '[:lower:]')"

  if [ "$par_impar" == "par" ] || [ "$par_impar" == "impar" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money$ ${endColour}${grayColour}como capital inicial${endColour}"
  else
    echo -e "\n${redColour}[!] Debes apostar a par o impar! Intentalo de nuevo!${endColour}"
    tput cnorm; exit 1
  fi

  # COMENZAMOS EL CODIGO DE LA LOGICA:
  
  # Declaramos la secuencia en un array
  declare -a secuencia=(1 2 3 4)

  # Declaramos la apuesta segun la secuencia
  declare -i bet=$((${secuencia[0]} + ${secuencia[-1]}))
  
  # Contador de jugadas
  declare -i play_counter=0

  # Insurance
  declare -i insurance=$(($money+50))

  # Maximos capitales dentro de un array para luego ordenarlos numericamente y buscar el mas grande para mostrarlo
  max_capital=()
  

  tput civis
  while true; do
  # Generamos el numero random
    random_number=$(($RANDOM % 37))


    if [ $money -gt 0 ]; then

      money=$(($money-$bet))

      if [ "$par_impar" == "par" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Nuestra secuencia en estos momentos es:${endColour}${blueColour} [${secuencia[@]}]${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos que apostar:${endColour}${yellowColour} $bet$ ${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Y nuestro dinero quedaria en:${endColour}${yellowColour} $money$ ${endColour}"
        if [ $money -le 0 ]; then
          echo -e "\n${redColour}[!] Por lo tanto no puedes continuar... te has quedado sin suficiente capital!${endColour}\n"
          echo -e "\t${blueColour}[+]${endColour}${grayColour} Han sido${endColour}${blueColour} $play_counter${endColour}${grayColour} jugadas en total${endColour}"

          # En el array vacio creamos esto para sacar cuanto fue lo maximo que estuvo el capital
          total_capital_max="$(echo -e "${max_capital[@]}" | tr ' ' '\n' | sort -nu | tail -n 1)"
          echo -e "\t${blueColour}[+]${endColour}${grayColour} Lo maximo que estuvo el capital fue:${endColour}${yellowColour} $total_capital_max$ ${endColour}"
          tput cnorm; exit 0
        fi

        echo -e "${yellowColour}[+]${endColour}${grayColour} VAMOOOOOS!${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"

        # Si sale PAR ganas
        if [ $(($random_number % 2)) -eq 0 ] && [ $random_number -ne 0 ]; then
          echo -e "${greenColour}[+] El numero es PAR, GANASTE!${endColour}"
          reward=$(($bet*2))
          let money+=$reward
          echo -e "${yellowColour}[+]${endColour}${grayColour} Acabamos de ganar:${endColour}${yellowColour} $reward$ ${endColour}"
          echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos un capital ahora de:${endColour}${yellowColour} $money$ ${endColour}"
          secuencia+=($bet)
          secuencia=(${secuencia[@]})
          bet=$((${secuencia[0]} + ${secuencia[-1]}))

          # creamos un seguro de dinero cuando superemos la zona segura
          if [ $money -gt $insurance ]; then
            echo -e "[+] El capital a superado la "zona segura" de $insurance, es hora de reiniciar la secuencia..."
            secuencia=(1 2 3 4)
            bet=$((${secuencia[0]} + ${secuencia[-1]}))
            insurance=$(($insurance+50))
            echo -e "[+] Ahora la nueva "zona segura" es de $insurance"
          fi

          # Aqui vamos sumando cada vez que el capital sube para luego ver cual fue la mayor cantidad
          max_capital+=($money)

        # Si sale IMPAR pierdes  
        elif [ $(($random_number % 2)) -eq 1 ] || [ $random_number -eq 0 ]; then

          if [ $(($random_number % 2)) -eq 1 ]; then
            echo -e "${redColour}[-] El numero es IMPAR, PERDISTE!${endColour}"
          elif [ $random_number -eq 0 ]; then
            echo -e "${redColour}[-] Ha salido el CERO, PERDISTE!${endColour}"
          fi

          echo -e "${yellowColour}[+]${endColour}${grayColour} Acabamos de perder:${endColour}${yellowColour} $bet$ ${endColour}"
          echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos un capital ahora de:${endColour}${yellowColour} $money$ ${endColour}"
          

          unset secuencia[0]
          unset secuencia[-1] 2>/dev/null

          secuencia=(${secuencia[@]})

          if [ ${#secuencia[@]} -eq 1 ]; then
            bet=${secuencia[0]}
          elif [ ${#secuencia[@]} -eq 0 ]; then
            secuencia=(1 2 3 4)
            bet=$((${secuencia[0]} + ${secuencia[-1]}))           
          fi

          # creamos un seguro de dinero cuando bajemos la zona segura
          if [ $money -lt $(($insurance-100)) ]; then
            echo -e "[+] El capital a bajado mucho, es hora de reiniciar la secuencia..."
            secuencia=(1 2 3 4)
            bet=$((${secuencia[0]} + ${secuencia[-1]}))
            insurance=$(($insurance-50))
            echo -e "[+] Ahora la nueva "zona segura" es de $insurance"
          fi          

        fi
        
      elif [ "$par_impar" == "impar" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Nuestra secuencia en estos momentos es:${endColour}${blueColour} [${secuencia[@]}]${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos que apostar:${endColour}${yellowColour} $bet$ ${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Y nuestro dinero quedaria en:${endColour}${yellowColour} $money$ ${endColour}"
        if [ $money -le 0 ]; then
          echo -e "\n${redColour}[!] Por lo tanto no puedes continuar... te has quedado sin suficiente capital!${endColour}\n"
          echo -e "\t${blueColour}[+]${endColour}${grayColour} Han sido${endColour}${blueColour} $play_counter${endColour}${grayColour} jugadas en total${endColour}"

          # En el array vacio creamos esto para sacar cuanto fue lo maximo que estuvo el capital
          total_capital_max="$(echo -e "${max_capital[@]}" | tr ' ' '\n' | sort -nu | tail -n 1)"
          echo -e "\t${blueColour}[+]${endColour}${grayColour} Lo maximo que estuvo el capital fue:${endColour}${yellowColour} $total_capital_max$ ${endColour}"
          tput cnorm; exit 0
        fi

        echo -e "${yellowColour}[+]${endColour}${grayColour} VAMOOOOOS!${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"

        # Si sale IMPAR ganas
        if [ $(($random_number % 2)) -eq 1 ] && [ $random_number -ne 0 ]; then
          echo -e "${greenColour}[+] El numero es IMPAR, GANASTE!${endColour}"
          reward=$(($bet*2))
          let money+=$reward
          echo -e "${yellowColour}[+]${endColour}${grayColour} Acabamos de ganar:${endColour}${yellowColour} $reward$ ${endColour}"
          echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos un capital ahora de:${endColour}${yellowColour} $money$ ${endColour}"
          secuencia+=($bet)
          secuencia=(${secuencia[@]})
          bet=$((${secuencia[0]} + ${secuencia[-1]}))

          # creamos un seguro de dinero cuando superemos la zona segura
          if [ $money -gt $insurance ]; then
            echo -e "[+] El capital a superado la "zona segura" de $insurance, es hora de reiniciar la secuencia..."
            secuencia=(1 2 3 4)
            bet=$((${secuencia[0]} + ${secuencia[-1]}))
            insurance=$(($insurance+50))
            echo -e "[+] Ahora la nueva "zona segura" es de $insurance"
          fi

          # Aqui vamos sumando cada vez que el capital sube para luego ver cual fue la mayor cantidad
          max_capital+=($money)

        # Si sale PAR pierdes  
        elif [ $(($random_number % 2)) -eq 0 ] || [ $random_number -eq 0 ]; then

          if [ $(($random_number % 2)) -eq 0 ]; then
            echo -e "${redColour}[-] El numero es PAR, PERDISTE!${endColour}"
          elif [ $random_number -eq 0 ]; then
            echo -e "${redColour}[-] Ha salido el CERO, PERDISTE!${endColour}"
          fi

          echo -e "${yellowColour}[+]${endColour}${grayColour} Acabamos de perder:${endColour}${yellowColour} $bet$ ${endColour}"
          echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos un capital ahora de:${endColour}${yellowColour} $money$ ${endColour}"
          

          unset secuencia[0]
          unset secuencia[-1] 2>/dev/null

          secuencia=(${secuencia[@]})

          if [ ${#secuencia[@]} -eq 1 ]; then
            bet=${secuencia[0]}
          elif [ ${#secuencia[@]} -eq 0 ]; then
            secuencia=(1 2 3 4)
            bet=$((${secuencia[0]} + ${secuencia[-1]}))           
          fi

          # creamos un seguro de dinero cuando bajemos la zona segura
          if [ $money -lt $(($insurance-100)) ]; then
            echo -e "[+] El capital a bajado mucho, es hora de reiniciar la secuencia..."
            secuencia=(1 2 3 4)
            bet=$((${secuencia[0]} + ${secuencia[-1]}))
            insurance=$(($insurance-50))
            echo -e "[+] Ahora la nueva "zona segura" es de $insurance"
          fi
          

        fi

      fi

    fi
    let play_counter+=1
    #sleep 2
  done
  tput cnorm
}

function helpPanel(){
  echo -e "\n${yellowColour}[!]${endColour}${grayColour} Modo de uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour}${grayColour} Tecnica a utilizar${endColour} ${purpleColour}(${endColour}${yellowColour}Martingala${endColour}${purpleColour}/${endColour}${yellowColour}InverseLabrouchere${endColour}${purpleColour})${endColour}"
  exit 0
}

while getopts "m:t:h" arg; do
  case $arg in
    m) declare -i money="$OPTARG";;
    t) technique="$OPTARG";;
    h) helpPanel;;
  esac
done

technique="$(echo $technique | tr '[:upper:]' '[:lower:]')"

if [ "$money" ] && [ "$technique" ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverselabrouchere" ]; then
    inverselabrouchere
  else
    echo -e "\n${yellowColour}[!]${endColour}${redColour} La tecnica introducida no existe, intenta de nuevo!${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
