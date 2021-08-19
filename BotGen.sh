#!/bin/bash
# -*- ENCODING: UTF-8 -*-
  
CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}
SRC="${CIDdir}/sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
CID="${CIDdir}/User-ID" && [[ ! -e ${CID} ]] && echo > ${CID}
CUS="${CIDdir}/custom" && [[ ! -d ${CUS} ]] && mkdir ${CUS}
keytxt="${CIDdir}/keys" && [[ ! -d ${keytxt} ]] && mkdir ${keytxt}
#[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ -e /etc/texto-bot ]] && rm /etc/texto-bot
LINE="==========================="

# Importando API
source ${CIDdir}/ShellBot.sh
source ${SRC}/menu
source ${SRC}/ayuda
source ${SRC}/cache
source ${SRC}/invalido
source ${SRC}/status
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

# Token del bot
bot_token="$(cat ${CIDdir}/token)"

# Inicializando el bot
ShellBot.init --token "$bot_token" --monitor --flush --return map
ShellBot.username

del_msj(){
	msg[0]="${message_message_id[$id]}"
	msg[1]="$1"
	
	for i in ${msg[@]}; do
		ShellBot.deleteMessage  --chat_id ${message_chat_id[$id]} \
								--message_id "${i}"
	done
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

	if [[ $(echo $permited|grep "${chatuser}") = "" ]]; then
				# ShellBot.sendMessage 	--chat_id ${message_chat_id[$id]} \
				ShellBot.sendMessage 	--chat_id $var \
										--text "<i>$(echo -e $bot_retorno)</i>" \
										--parse_mode html \
										--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_user')"
	else
				# ShellBot.sendMessage 	--chat_id ${message_chat_id[$id]} \
				ShellBot.sendMessage 	--chat_id $var \
										--text "<i>$(echo -e $bot_retorno)</i>" \
										--parse_mode html \
										--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_conf')"
	fi
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
                             --caption  "$(echo -e "$bot_retorno")"
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
botao_user=''
botao_donar=''

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'add' --callback_data '/add'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'del' --callback_data '/del'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'list' --callback_data '/list'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'ID' --callback_data '/ID'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'power' --callback_data '/power'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'menu' --callback_data '/menu'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text 'keygen' --callback_data '/keygen'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 1 --text 'keygen' --callback_data '/keygen'

ShellBot.InlineKeyboardButton --button 'botao_donar' --line 1 --text 'Donar Paypal' --callback_data '1' --url 'https://www.paypal.me/Rufu99'
ShellBot.InlineKeyboardButton --button 'botao_donar' --line 2 --text 'Donar MercadoPago ARG' --callback_data '1' --url 'http://mpago.li/1SAHrwu'
ShellBot.InlineKeyboardButton --button 'botao_donar' --line 3 --text 'Acortador adf.ly' --callback_data '1' --url 'http://caneddir.com/2J9J'

# Ejecutando escucha del bot
while true; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates); do

	    chatuser="$(echo ${message_chat_id[$id]}|cut -d'-' -f2)"
	    [[ -z $chatuser ]] && chatuser="$(echo ${callback_query_from_id[$id]}|cut -d'-' -f2)"

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
