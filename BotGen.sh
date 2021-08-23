#!/bin/bash
# -*- ENCODING: UTF-8 -*-
  
CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}
SRC="${CIDdir}/sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
CID="${CIDdir}/User-ID" && [[ ! -e ${CID} ]] && echo > ${CID}
CUS="${CIDdir}/custom" && [[ ! -d ${CUS} ]] && mkdir ${CUS}
keytxt="${CIDdir}/keys" && [[ ! -d ${keytxt} ]] && mkdir ${keytxt}
#[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ -e /etc/texto-bot ]] && rm /etc/texto-bot
LINE="━━━━━━━━━━━━━━━"

# Importando API
source ${CIDdir}/ShellBot.sh
source ${SRC}/menu
source ${SRC}/ayuda
source ${SRC}/cache
source ${SRC}/invalido
source ${SRC}/reinicio
source ${SRC}/myip
source ${SRC}/id
source ${SRC}/back_ID
source ${SRC}/link
source ${SRC}/listID
source ${SRC}/gerar_key
source ${SRC}/power
source ${SRC}/comandos
source ${SRC}/update
source ${SRC}/donar
source ${SRC}/extras

# Token del bot
bot_token="$(cat ${CIDdir}/token)"

# Inicializando el bot
ShellBot.init --token "$bot_token" --monitor --flush --return map
ShellBot.username

ShellBot.setMyCommands --commands '[{"command":"menu","description":"muestra el menu principal"},{"command":"id","description":"muestra tu id de telegram"}]'

comand_boton(){
	if [[ ${comando[1]} = "edit" ]]; then
		edit_msj_boton "botao_$1"
	else
		menu_print "botao_$1"
	fi
}

getinf(){

	ShellBot.getChatMember  --chat_id "$1" \
							--user_id "$1"
	bot_retorno="$LINE\n"
	bot_retorno+="<u>Nombre:</u> ${return[user_first_name]}\n"
	bot_retorno+="<u>Apellido:</u> ${return[user_last_name]}\n"
	bot_retorno+="<u>Usuario:</u> ${return[user_username]}\n"
	bot_retorno+="<u>ID de usuario:</u> ${return[user_id]}\n"
	bot_retorno+="$LINE"
	msj_fun

return 0
}

del_msj(){
	msg[0]="${message_message_id[$id]}"
	msg[1]="$1"
	
	for i in ${msg[@]}; do
		ShellBot.deleteMessage  --chat_id ${message_chat_id[$id]} \
								--message_id "${i}"
	done
	return 0
}

edit_msj_boton(){
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	[[ ! -z ${callback_query_message_message_id[id]} ]] && message=${callback_query_message_message_id[id]} || message=${return[message_id]}

		ShellBot.editMessageText --chat_id $var \
								 --text "<i>$(echo -e "$bot_retorno")</i>" \
								 --message_id "${message}" \
								 --parse_mode html \
								 --reply_markup "$(ShellBot.InlineKeyboardMarkup -b "$1")"
}

edit_msj(){
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	[[ ! -z ${callback_query_message_message_id[id]} ]] && message=${callback_query_message_message_id[id]} || message=${return[message_id]}

		ShellBot.editMessageText --chat_id $var \
								 --text "<i>$(echo -e "$bot_retorno")</i>" \
								 --message_id "${message}" \
								 --parse_mode html
}

reply () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

		 	 ShellBot.sendMessage	--chat_id  $var \
									--text "<i>$(echo -e "$bot_retorno")</i>" \
									--parse_mode html \
									--reply_markup "$(ShellBot.ForceReply)"
	return 0
	#[[ "${callback_query_data}" = /del || "${message_text}" = /del ]] && listID_src
}

menu_print () {
[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

				ShellBot.sendMessage 	--chat_id $var \
										--text "<i>$(echo -e $bot_retorno)</i>" \
										--parse_mode html \
										--reply_markup "$(ShellBot.InlineKeyboardMarkup -b "$1")"
}

download_file () {
# shellbot.sh editado linea 3986
user=User-ID
[[ -e ${CID} ]] && rm ${CID}
local file_id
          ShellBot.getFile --file_id ${message_document_file_id[$id]}
          ShellBot.downloadFile --file_path "${return[file_path]}" --dir "${CIDdir}"
local bot_retorno="Copia de serguridad\n"
		bot_retorno+="$LINE\n"
		bot_retorno+="Se restauro con exito!!\n"
		bot_retorno+="$LINE\n"
		bot_retorno+="${return[file_path]}\n"
		bot_retorno+="$LINE"
		del_msj
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--text "<i>$(echo -e $bot_retorno)</i>" \
									--parse_mode html
return 0
}

msj_add () {
	      ShellBot.sendMessage --chat_id ${1} \
							--text "<i>$(echo -e $bot_retor)</i>" \
							--parse_mode html
}

upfile_fun () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
          ShellBot.sendDocument --chat_id $var  \
                             --document @${1} \
                             --caption  "$(echo -e "$bot_retorno")" \
                             --reply_markup "$(ShellBot.InlineKeyboardMarkup -b "$2")"
}

invalido_fun () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
local bot_retorno="$LINE\n"
         bot_retorno+="Comando invalido!\n"
         bot_retorno+="$LINE\n"
	     ShellBot.sendMessage --chat_id $var \
							--text "<i>$(echo -e $bot_retorno)</i>" \
							--parse_mode html
	return 0	
}

msj_fun(){
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	      ShellBot.sendMessage --chat_id $var \
							--text "<i>$(echo -e "$bot_retorno")</i>" \
							--parse_mode html
	return 0
}

msj_donar () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	      ShellBot.sendMessage --chat_id $var \
							--text "<i>$(echo -e "$bot_retorno")</i>" \
							--parse_mode html \
							--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_donar')"
	return 0
}


botao_conf=''
botao_donar=''
botao_extra=''
botao_atras=''
botao_up=''
botao_list=''

botao_user=''
botao_user2=''

botao_key=''

ShellBot.InlineKeyboardButton --button 'botao_user' --line 1 --text 'ID' --callback_data '/id edit'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 1 --text 'ayuda' --callback_data '/ayuda edit'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 2 --text 'menu' --callback_data '/menu'

ShellBot.InlineKeyboardButton --button 'botao_user2' --line 1 --text 'ID' --callback_data '/id edit'
ShellBot.InlineKeyboardButton --button 'botao_user2' --line 1 --text 'menu' --callback_data '/menu edit'
ShellBot.InlineKeyboardButton --button 'botao_user2' --line 1 --text 'ayuda' --callback_data '/ayuda edit'
ShellBot.InlineKeyboardButton --button 'botao_user2' --line 2 --text 'keygen' --callback_data '/keygen'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'add' --callback_data '/add'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'del' --callback_data '/del'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'list' --callback_data '/list edit'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'ID' --callback_data '/ID edit'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'extra' --callback_data '/extra edit'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'power' --callback_data '/power edit'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'menu' --callback_data '/menu'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text 'cache' --callback_data '/cache edit'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text 'keygen' --callback_data '/keygen'

ShellBot.InlineKeyboardButton --button 'botao_extra' --line 1 --text 'actualizar' --callback_data '/actualizar'
ShellBot.InlineKeyboardButton --button 'botao_extra' --line 1 --text 'reboot' --callback_data '/reboot'
ShellBot.InlineKeyboardButton --button 'botao_extra' --line 1 --text 'ayuda' --callback_data '/ayuda'
ShellBot.InlineKeyboardButton --button 'botao_extra' --line 2 --text '<<< menu' --callback_data '/menu edit'

ShellBot.InlineKeyboardButton --button 'botao_atras' --line 1 --text 'menu' --callback_data '/menu edit'

ShellBot.InlineKeyboardButton --button 'botao_list' --line 1 --text 'menu' --callback_data '/menu edit'
ShellBot.InlineKeyboardButton --button 'botao_list' --line 1 --text 'info' --callback_data '/info'

ShellBot.InlineKeyboardButton --button 'botao_up' --line 1 --text 'menu' --callback_data '/menu'

ShellBot.InlineKeyboardButton --button 'botao_key' --line 1 --text 'menu' --callback_data '/menu'
ShellBot.InlineKeyboardButton --button 'botao_key' --line 1 --text 'keygen' --callback_data '/keygen'

ShellBot.InlineKeyboardButton --button 'botao_donar' --line 1 --text 'Donar Paypal' --callback_data '1' --url 'https://www.paypal.me/Rufu99'
ShellBot.InlineKeyboardButton --button 'botao_donar' --line 2 --text 'Donar MercadoPago ARG' --callback_data '1' --url 'http://mpago.li/1SAHrwu'
ShellBot.InlineKeyboardButton --button 'botao_donar' --line 3 --text 'Acortador adf.ly' --callback_data '1' --url 'http://caneddir.com/2J9J'

# Ejecutando escucha del bot
while true; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates); do

	    chatuser="$(echo ${message_chat_id[$id]}|cut -d'-' -f2)"
	    [[ -z $chatuser ]] && chatuser="$(echo ${callback_query_from_id[$id]}|cut -d'-' -f2)"

	    if [[ ! $(cat ${CIDdir}/ban|grep "${chatuser}") = "" ]]; then
	    	continue
	    fi

	    if [[ ! -z ${message_text[$id]} ]]; then
	    	comando=(${message_text[$id]})
	    elif [[ ! -z ${callback_query_data[$id]} ]]; then
	    	comando=(${callback_query_data[$id]})
	    fi

	    [[ ! -e "${CIDdir}/Admin-ID" ]] && echo "null" > ${CIDdir}/Admin-ID
	    permited=$(cat ${CIDdir}/Admin-ID)
	    comand
    done
done
