#!/bin/bash
REQUEST="https://raw.githubusercontent.com/rudi9999/TeleBotGen/main"
DIR="/etc/http-shell"
LIST="lista-arq"
CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}

msg () {
local colors="${ADM_tmp}/ADM-color"

if [[ ! -e $colors ]]; then
COLOR[0]='\033[1;37m' #BRAN='\033[1;37m'
COLOR[1]='\e[31m' #VERMELHO='\e[31m'
COLOR[2]='\e[32m' #VERDE='\e[32m'
COLOR[3]='\e[33m' #AMARELO='\e[33m'
COLOR[4]='\e[34m' #AZUL='\e[34m'
COLOR[5]='\e[91m' #MAGENTA='\e[35m'
COLOR[6]='\033[1;97m' #MAG='\033[1;36m'
COLOR[7]='\e[36m' #teal='\e[36m'
COLOR[8]='\e[30m' #negro='\e[30m'
else
local COL=0
for number in $(cat $colors); do
case $number in
1)COLOR[$COL]='\033[1;37m';;
2)COLOR[$COL]='\e[31m';;
3)COLOR[$COL]='\e[32m';;
4)COLOR[$COL]='\e[33m';;
5)COLOR[$COL]='\e[34m';;
6)COLOR[$COL]='\e[35m';;
7)COLOR[$COL]='\033[1;36m';;
esac
let COL++
done
fi
NEGRITO='\e[1m'
SEMCOR='\e[0m'
 case $1 in
  -ne)   cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -ama)  cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm2)cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -teal) cor="${COLOR[7]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -teal2) cor="${COLOR[7]}" && echo -e "${cor}${2}${SEMCOR}";;
  -blak) cor="${COLOR[8]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -blak2) cor="${COLOR[8]}" && echo -e "${cor}${2}${SEMCOR}";;
  -azu)  cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bra)  cor="${COLOR[0]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bar)  cor="${COLOR[1]}=====================================================" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
  -bar2) cor="${COLOR[7]}=====================================================" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
  -bar3) cor="${COLOR[1]}-----------------------------------------------------" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
  -bar4) cor="${COLOR[7]}-----------------------------------------------------" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
 esac
}

print_center(){
    local x
    local y
    #text="$*"
    text="$2"
    x=$(( ($(tput cols) - ${#text}) / 2))
    echo -ne "\E[6n";read -sdR y; y=$(echo -ne "${y#*[}" | cut -d';' -f1)
    #echo -e "\033[${y};${x}f$*"
    msg "$1" "\033[${y};${x}f$2"
}

menu_func () {
  local options=${#@}
  local array
  for((num=1; num<=$options; num++)); do
    echo -ne "$(msg -verd " [$num]") $(msg -teal ">") "
    array=(${!num})
    case ${array[0]} in
      "-vd")echo -e "\033[1;33m[!]\033[1;32m ${array[@]:1}";;
      "-vm")echo -e "\033[1;33m[!]\033[1;31m ${array[@]:1}";;
      "-fi")echo -e "${array[@]:2} ${array[1]}";;
      *)echo -e "\033[1;37m${array[@]}";;
    esac
  done
 }

 # SISTEMA DE SELECAO
selection_fun () {
	local selection="null"
	local range
	for((i=0; i<=$1; i++)); do range[$i]="$i "; done
	while [[ ! $(echo ${range[*]}|grep -w "$selection") ]]; do
		echo -ne "\033[1;37mSelecione una Opcion: " >&2
		read selection
		tput cuu1 >&2 && tput dl1 >&2
	done
	echo $selection
}

check_ip () {
  if [[ -e ${CIDdir}/MEUIPBOT ]]; then
    echo "$(cat ${CIDdir}/MEUIPBOT)"
  else
    MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
    MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
    [[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" && echo "$MEU_IP2" || IP="$MEU_IP" && echo "$MEU_IP"
    echo "$MEU_IP2" > ${CIDdir}/MEUIPBOT
  fi
}

function_verify () {
  permited=$(curl -sSL "https://raw.githubusercontent.com/rudi9999/Control/master/Control-Bot")
  [[ $(echo $permited|grep "${IP}") = "" ]] && {
  clear
  echo -e "\n\n\n\e[31m====================================================="
  echo -e "\e[31m      ¡LA IP $(wget -qO- ipv4.icanhazip.com) NO ESTA AUTORIZADA!\n     SI DESEAS USAR EL BOTGEN CONTACTE A @Rufu99"
  echo -e "\e[31m=====================================================\n\n\n\e[0m"
  #[[ -d /etc/ADM-db ]] && rm -rf /etc/ADM-db
  #[[ ! -e "/bin/ShellBot.sh" ]] && rm /bin/ShellBot.sh
  exit 1
  } || {
  ### INTALAR VERCION DE SCRIPT
  v1=$(curl -sSL "https://raw.githubusercontent.com/rudi9999/TeleBotGen/main/Vercion")
  echo "$v1" > /etc/ADM-db/vercion
  }
}

veryfy_fun () {
	SRC="/etc/ADM-db/sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
	unset ARQ
	case $1 in
		"BotGen.sh"|"BotGen-server.sh"|"ShellBot.sh")ARQ="/etc/ADM-db/";;
		*)ARQ="/etc/ADM-db/sources/";;
	esac
	mv -f $HOME/$1 ${ARQ}/$1
	chmod +x ${ARQ}/$1
}

download () {
	clear
	msg -bar2
	echo -e "\033[1;33mDescargando archivos... "
	msg -bar2
	cd $HOME
	wget -O "$HOME/lista-arq" ${REQUEST}/lista-bot > /dev/null 2>&1
	sleep 1s
	[[ -e $HOME/lista-arq ]] && {
		for arqx in `cat $HOME/lista-arq`; do
			echo -ne "\033[1;33mDescargando: \033[1;31m[$arqx] "
			wget -O $HOME/$arqx ${REQUEST}/${arqx} > /dev/null 2>&1 && {
				echo -e "\033[1;31m- \033[1;32mRecibido!"
				[[ -e $HOME/$arqx ]] && veryfy_fun $arqx
			} || echo -e "\033[1;31m- \033[1;31mFalla (no recibido!)"
		done
	}
	rm $HOME/lista-arq
}

ini_token () {
	clear
	msg -bar2
	print_center -azu "Ingrese el token de su bot"
	msg -bar2
	echo -n "TOKEN: "
	read opcion
	echo "$opcion" > ${CIDdir}/token
	msg -bar2
	print_center -verd "token se guardo con exito!"
	msg -bar2
	echo -e "  \033[1;37mPara tener acceso a todos los comandos del bot\n  deve iniciar el bot en la opcion 2.\n  desde su apps (telegram). ingresar al bot!\n  digite el comando \033[1;31m/id\n  \033[1;37mel bot le respodera con su ID de telegram.\n  copiar el ID e ingresar el mismo en la opcion 3"
	msg -bar2
	read foo
	return 1
}

ini_id () {
	clear
	msg -bar2
	print_center -azu "Ingrese su ID de telegram"
	msg -bar2
	echo -n "ID: "
	read opcion
	echo "$opcion" > ${CIDdir}/Admin-ID
	msg -bar2
	print_center -verd "ID guardo con exito!"
	msg -bar2
	echo -e "  \033[1;37mdesde su apps (telegram). ingresar al bot!\n  digite el comando \033[1;31m/menu\n  \033[1;37mprueve si tiene acceso al menu extendido."
	msg -bar2
	read foo
	return 1
}

start_bot(){
	clear
	unset fail
	msg -bar2
	[[ ! -e "${CIDdir}/token" ]] && echo "null" > ${CIDdir}/token
	unset PIDGEN
	PIDGEN=$(ps aux|grep -v grep|grep "BotGen.sh")

	if [[ ! $PIDGEN ]]; then
echo -e "[Unit]
Description=BotGen Service by @Rufu99
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/bin/bash ${CIDdir}/BotGen.sh
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/BotGen.service

echo -e "[Unit]
Description=BotGen-server Service by @Rufu99
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/bin/bash ${CIDdir}/BotGen-server.sh -start
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/BotGen-server.service

	if systemctl enable BotGen-server &>/dev/null; then
    	print_center -verd "Servicio BotGen-server activo"
    else
    	print_center -verm2 "Falla al activar servicio BotGen-server"
    	return 1
    fi

    if systemctl start BotGen-server; then
    	print_center -verd "Servicio BotGen-server iniciado"
    else
    	print_center -verm2 "Falla al iniciar servicio BotGen-server"
    	return 1
    fi

    msg -bar4

    if systemctl enable BotGen &>/dev/null; then
    	print_center -verd "Servicio BotGen activo"
    else
    	print_center -verm2 "Falla al activar servicio BotGen"
    	return 1
    fi

    if systemctl start BotGen; then
    	print_center -verd "Servicio BotGen iniciado"
    else
    	print_center -verm2 "Falla al iniciar servicio BotGen"
    	return 1
    fi

    msg -bar2
    print_center -verd "BotGen en linea"
    msg -bar2

else

	if systemctl stop BotGen; then
    	print_center -ama "Servicio BotGen detenido"
    else
    	print_center -verm2 "Falla al detener servicio BotGen"
    	fail=1
    fi
    if systemctl disable BotGen &>/dev/null; then
    	print_center -ama "Servicio BotGen desactivado"
    	rm /etc/systemd/system/BotGen.service
    else
    	rm -rf /etc/systemd/system/BotGen.service
    	print_center -verm2 "Falla al desactivar servicio BotGen"
    	fail=1
    fi

    msg -bar4

    if systemctl stop BotGen-server; then
    	print_center -ama "Servicio BotGen-server detenido"
    else
    	print_center -verm2 "Falla al detener servicio BotGen-server"
    	fail=1
    fi
    if systemctl disable BotGen-server &>/dev/null; then
    	print_center -ama "Servicio BotGen-server desactivado"
    	rm /etc/systemd/system/BotGen-server.service
    else
    	rm -rf /etc/systemd/system/BotGen-server.service
    	print_center -verm2 "Falla al desactivar servicio BotGen-server"
    	fail=1
    fi
    msg -bar2
    if [[ -z $fail ]]; then
    	print_center -verd "BotGen fuera de linea"
    else
    	print_center -verm2 "ERROR AL DETENER SERVICIOS"
    	print_center -ama "intente reiniciando el servidor!"
    fi
    msg -bar2
fi
read foo
return 1
}

start_gen () {
unset PIDGEN
PIDGEN=$(ps aux|grep -v grep|grep "http-server.sh")
if [[ ! $PIDGEN ]]; then
screen -dmS generador /bin/http-server.sh -start
registro generador_online
clear
msg -bar
echo -e "\033[1;32m                Generador en linea"
msg -bar
echo -ne "\033[1;97m Poner en linea despues de un reinicio [s/n]: "
read start_ini
msg -bar
[[ $start_ini = @(s|S|y|Y) ]] && {
	crontab -l > /root/cron
	echo "@reboot screen -dmS generador /bin/http-server.sh -start" >> /root/cron
	crontab /root/cron
	rm /root/cron
}
else
killall http-server.sh
registro generador_offline
crontab -l > /root/cron
sed -i '/http-server.sh/ d' /root/cron
crontab /root/cron
rm /root/cron
clear
msg -bar
echo -e "\033[1;31m            Generador fuera de linea"
msg -bar
sleep 3
fi
}

ayuda_fun () {
	clear
	msg -bar2
	echo -e "            \e[47m\e[30m Instrucciones rapidas \e[0m"
	msg -bar2
	echo -e "\033[1;37m   Es necesario crear un bot en \033[1;32m@BotFather "
	msg -bar2
	echo -e "\033[1;32m1- \033[1;37mEn su apps telegram ingrese a @BotFather\n"

	echo -e "\033[1;32m2- \033[1;37mDigite el comando \033[1;31m/newbot\n"

	echo -e "\033[1;32m3- @BotFather \033[1;37msolicitara que\n   asigne un nombre a su bot\n"

	echo -e "\033[1;32m4- @BotFather \033[1;37msolicitara que asigne otro nombre,\n   esta vez deve finalizar en bot eje: \033[1;31mXXX_bot\n"

	echo -e "\033[1;32m5- \033[1;37mObtener token del bot creado.\n   En \033[1;32m@BotFather \033[1;37mdigite el comando \033[1;31m/token\n   \033[1;37mseleccione el bot y copie el token.\n"

	echo -e "\033[1;32m6- \033[1;37mIngrese el token\n   en la opcion \033[1;32m[1] \e[36m> \033[1;37mTOKEN DEL BOT\n"

	echo -e "\033[1;32m7- \033[1;37mPoner en linea el bot\n   en la opcion \033[1;32m[4] \e[36m> \033[1;37mINICIAR/PARAR BOT\n"

	echo -e "\033[1;32m8- \033[1;37mEn su apps telegram, inicie el bot creado\n   digite el comando \033[1;31m/id \033[1;37mel bot le respondera\n   con su ID de telegran (copie el ID)\n"

	echo -e "\033[1;32m9- \033[1;37mIngrese el ID en la\n   opcion \033[1;32m[2] \e[36m> \033[1;37mID DE USUARIO TELEGRAM\n"

	echo -e "\033[1;32m10- \033[1;37mcomprueve que tiene acceso a\n   las opciones avanzadas de su bot.\n"

	msg -ama " NOTA: El bot tiene ajuste predefinidos\n       por su desarrollador.\n       los que deveras modificar en\n       la opcion \033[1;32m[6] \e[36m> $( msg -teal "AJUSTES Y PERSONALIZAR")"
	msg -bar2
	read foo
	return 1
}

msj_prueba () {
	TOKEN="$(cat /etc/ADM-db/token)"
	ID="$(cat /etc/ADM-db/Admin-ID)"
	[[ -z $TOKEN ]] && {
		clear
		msg -bar2
		echo -e "\033[1;37m Aun no a ingresado el token\n No se puede enviar ningun mensaje!"
		msg -bar2
		read foo
	} || {
		[[ -z $ID ]] && {
			clear
			msg -bar2
			echo -e "\033[1;37m Aun no a ingresado el ID\n No se puede enviar ningun mensaje!"
			msg -bar2
			read foo
		} || {
			MENSAJE="Esto es un mesaje de prueba!"
			URL="https://api.telegram.org/bot$TOKEN/sendMessage"
			curl -s -X POST $URL -d chat_id=$ID -d text="$MENSAJE" &>/dev/null
			clear
			msg -bar2
			echo -e "\033[1;37m mensaje enviado...!"
			msg -bar2
			sleep 2
		}
	}
	return 1
}

custom_txt(){
	case ${1} in
		link)echo "LINK INSTALADOR";;
		script)echo "DIR SCRIPT";;
		nombre)echo "NOMBRE DEL SCRIPT";;
		admin)echo "CONTACTO CON ADMIN";;
		port)echo "PUERTO KEYS";;
	esac
}

custom_cfg(){
	clear
	cust=$1
	[[ ! -e "${CIDdir}/custom/${cust}" ]] && touch ${CIDdir}/custom/${cust}
	inst="$(cat ${CIDdir}/custom/${cust})"
	msg -bar2
	print_center -ama "$(custom_txt ${cust})"
	msg -bar2
	echo ""
	if [[ ! -z $inst ]]; then
		print_center -verd "$(custom_txt ${cust}) INSTALADO\n"
		[[ ${cust} = "link" ]] && msg -ama "$inst" || print_center -ama "$inst"
		echo ""
		msg -bar2
		echo -ne "\033[1;37m desea continuar? [S/N]: "
		read cont
		[[ $cont = @(n|N) ]] && return 1
	fi
	tput cuu1 && tput dl1
	print_center -azu "INGRESE $(custom_txt ${cust})\n"
	read inst
	echo -e "$inst" > ${CIDdir}/custom/${cust}
	msg -bar2
	[[ -z $inst ]] && print_center -verm2 "$(custom_txt ${cust}) REMOVIDO" || print_center -verd "$(custom_txt ${cust}) GUARDADO"
	msg -bar2
	sleep 2
	return 1
}

custom(){
	clear
	[[ ! -d "${CIDdir}/custom" ]] && mkdir ${CIDdir}/custom
	msg -bar2
	print_center -azu "MENU DE PERSONALIZACION DEL BOT"
	msg -bar2
	menu_func "$(custom_txt link)" \
	"$(custom_txt script)" \
	"$(custom_txt nombre)" \
	"$(custom_txt admin)" \
	"$(custom_txt port)"
	msg -bar2
	echo -e " $(msg -verd "[0]") $(msg -teal ">") \e[47m $(msg -blak2 "<< ATRAS ")"
	msg -bar2
	echo -ne " opcion: "
	read cust

	case $cust in
		1)custom_cfg link;;
		2)custom_cfg script;;
		3)custom_cfg nombre;;
		4)custom_cfg admin;;
		5)custom_cfg port;;
		0)return 1;;
	esac
}

restart_bot(){
	clear
	unset fail
	msg -bar2
	print_center -azu "REINICIANDO BOTGEN"
	msg -bar2
	if systemctl restart BotGen-server &>/dev/null; then
		print_center -verd "servicio BotGen-server reiniciando"
	else
		print_center -verm2 "Falla al reiniciar servicio BotGen-server"
		fail=1
	fi

	msg -bar4

	if systemctl restart BotGen &>/dev/null; then
		print_center -verd "servicio BOTGEN reiniciando"
	else
		print_center -verm2 "Falla al reiniciar servicio BOTGEN"
		fail=1
	fi

	msg -bar2
    if [[ -z $fail ]]; then
    	print_center -verd "BotGen reiniciando"
    else
    	print_center -verm2 "ERROR AL REINICIAR SERVICIOS"
    	print_center -ama "intente reiniciando el servidor!"
    fi
    msg -bar2
    read foo
    return 1

}

ofus () {
	unset server
	server=$(echo ${txt_ofuscatw}|cut -d':' -f1)
	unset txtofus
	number=$(expr length $1)
	for((i=1; i<$number+1; i++)); do
		txt[$i]=$(echo "$1" | cut -b $i)
		case ${txt[$i]} in
			".")txt[$i]="*";;
			"*")txt[$i]=".";;
			"1")txt[$i]="@";;
			"@")txt[$i]="1";;
			"2")txt[$i]="?";;
			"?")txt[$i]="2";;
			"4")txt[$i]="%";;
			"%")txt[$i]="4";;
			"-")txt[$i]="K";;
			"K")txt[$i]="-";;
		esac
		txtofus+="${txt[$i]}"
	done
	echo "$txtofus" | rev
}

remover_key () {
	unset i
	unset keys
	unset value
	i=0
	[[ -z $(ls $DIR|grep -v "ERROR-KEY") ]] && return 1
	clear
	msg -bar2
	echo -ne "\e[47m"
	print_center -blak2 " <<< Lista de Keys >>> "
	msg -bar2

	keys="$keys retorno"
	for arqs in `ls $DIR|grep -v "ERROR-KEY"|grep -v ".name"`; do
		arqsx=$(ofus "$(check_ip):8888/$arqs/$LIST")
		let i++

		if [[ ! -e ${DIR}/${arqs}/used.date ]] && [[ ! -e ${DIR}/${arqs}/key.fija ]]; then
			echo -e "$(msg -verd "[$i]") \033[0;49;93m$arqsx\n          \033[0;49;36m($(cat ${DIR}/${arqs}.name))\033[1;32m (ACTIVA)\033[0m"
		elif [[ ! -e ${DIR}/${arqs}/key.fija ]]; then
			echo -e "$(msg -verd "[$i]") \033[0;49;31m$arqsx\n    \033[0;49;36m($(cat ${DIR}/${arqs}.name))\033[5;49;31m (USADA): \033[0;49;93m$(cat ${DIR}/${arqs}/used.date) IP:$(cat ${DIR}/${arqs}/used)\033[0m"
		else
			echo -e "$(msg -verd "[$i]") \033[0;49;93m$arqsx\n          \033[0;49;36m($(cat ${DIR}/${arqs}.name)) \033[0;49;34m($(cat ${DIR}/${arqs}/key.fija))\033[0m"
		fi
		msg -bar4
		keys="$keys $arqs"
	done

	keys=($keys)
	tput cuu1 >&2 && tput dl1 >&2
	msg -bar2
	echo -e " $(msg -verd "[0]") $(msg -teal ">") \e[47m$(msg -blak2 " << ATRAS ")"
	msg -bar2
	value=$(selection_fun $i)
	[[ -d "$DIR/${keys[$value]}" ]] && rm -rf $DIR/${keys[$value]}* && keydel=$(ofus "$(check_ip):8888/${keys[$value]}/$LIST") && remover_key
}

bot_gen () {
clear
unset PID_GEN
PID_GEN=$(ps x|grep -v grep|grep "BotGen.sh")
[[ ! $PID_GEN ]] && PID_GEN="\033[1;31moffline" || PID_GEN="\033[1;32monline"

CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}
msg -bar2
echo -ne "\e[47m\e[30m"
print_center -blak2 ">>>>>>  BotGen by Rufu99 $(cat ${CIDdir}/vercion) <<<<<<"
msg -bar2
menu_func "TOKEN DEL BOT" \
"ID DE USUARIO TELEGRAM" \
"MENSAJE DE PRUEBA\n$(msg -bar4)" \
"INICIAR/PARAR BOT $PID_GEN\033[0m\n$(msg -bar4)" \
"\e[33mREINICIAR BOTGEN" \
"\e[36mAJUSTES Y PERSONALIZAR\n$(msg -bar4)" \
"VER Y ELIMINAR KEYS"
msg -bar2
echo -e " $(msg -verd "[0]") $(msg -teal ">") \e[47m $(msg -blak2 "<< SALIR ")           $(msg -verd " [$num]") $(msg -teal ">") $(msg -azu "AYUDA")"
msg -bar2
echo -n " Opcion: "
read opcion
case $opcion in
0) return 0;;
1) ini_token;;
2) ini_id;;
3) msj_prueba;;
4) start_bot;;
5) restart_bot;;
6) custom;;
7) remover_key;;
8) ayuda_fun;;
*) bot_gen;;
esac
}

bot_conf () {
check_ip &>/dev/null
function_verify
instaled=/etc/ADM-db/sources && [[ ! -d ${instaled} ]] && download
}

bot_conf

while [[ ${back} != @(0) ]]; do
  bot_gen
  back="$?"
  [[ ${back} != @(0|[1]) ]] && msg -azu " Enter para continuar..." && read foo
done
