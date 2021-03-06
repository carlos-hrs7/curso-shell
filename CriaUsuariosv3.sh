#!/bin/bash

#################################################################################
#                                                                               #
# Nome: CriaUsuariosv3.sh							#
#										#
# Autor: Carlos Henrique Rezende Silva (carlos.professionalti@gmail.com)	#
# Data: 21/12/2017								#
#										#
# Descrição: Crie um script que faça criação de usuarios no sistema  	#
#            									#
#										#
# Uso: source CriaUsuariosv3.sh ou ./CriaUsuariosv3.sh				#
#										#	
#################################################################################

clear
echo ""
echo ""$0" - Script para criação de novos usuários no Linux ...."
echo ""

#Recebendo entrada do nome de login e nome completo para o novo usuario
read -p "Digite nome de Login para o novo usuário: " USUARIO
read -p "Digite o nome completo do novo usuário: " NOME

#Verificando se existe usuário e grupo com o mesmo nome inserido
echo ""
echo "Verificando se o usuário já existe no sistema ...."
sleep 2

#Condicional com comparação de strings

if FILTRO=$(grep $USUARIO /etc/passwd | cut -d":" -f1) #Verificando no arquivo /etc/passwd se já existe o usuário
then
		if [ "$USUARIO" = "$FILTRO" ]  #condicional, se var USUARIO for igual a var FILTRO, não cria o novo usuário
		then
		
			echo "Já existe um usuário no sistema com este nome! "
			echo "Finalizando o sistema ...."
			exit 1
			
		elif FILTRO2=$(grep $USUARIO /etc/group | cut -d":" -f1) #Verificando no arquivo /etc/group se já existe o grupo
		then
		
			echo "Verificando se já existe um grupo para o novo usuário ...."
			sleep 2 
	
			if [ "$USUARIO" = "$FILTRO2" ] #condicional, se var USUARIO for igual a var FILTRO2, não cria o usuário.
			then
				echo ""
				echo "Já existe no sistema um grupo com este nome! "
				echo "Finalizando o sistema ...."
				exit 2
			else #Se as duas condicionais acima forem falsas, então crie o novo usuário e grupo.

				echo ""
				echo "Usuário não existe no sistema, será criado o novo usuário e um grupo para ele ...."
				echo ""
			fi
		fi

fi

#Recebendo entrada para criação do diretorio home do usuário, por padrão o sistema não cria o home.
read -p "Deseja Criar o diretório HOME para o novo usuário? (S/n):" HOMEUSER

	if [ $HOMEUSER = S -o $HOMEUSER = s ] #condicional, se S ou s cria o usuario com o diretorio  home padrão 
	then
		echo ""
		echo "Criando o usuário no sistema com diretório home padrão ...."
		useradd $USUARIO -c "$NOME" -m
		echo ""
		echo "Usuário criado com Sucesso!"
	elif [ $HOMEUSER = N -o $HOMEUSER = n ] #condicional, se N ou n cria o usuario sem o diretorio home padrão
	then
		echo ""
		echo "Criando o usuário no sistema ...."
		echo "Diretório home padrão não será criado ...."
		useradd $USUARIO -c "$NOME"
		echo ""
		echo "Usuário criado com Sucesso!"
	else  

		echo ""
		echo "Opção Inválida!"
		echo "Finalizando o Sistema ...."
		exit 3
	fi

#Recebendo entrada para o shell padrão do novo usuário
echo ""
echo "Escolha um Shell de sua preferência: "
echo ""
echo " 1 - /bin/sh "
echo " 2 - /bin/dash "
echo " 3 - /bin/bash "
echo " 4 - /bin/rbash "
echo " 5 - /bin/ksh "
echo " 6 - /bin/zsh "
echo " 7 -  Nenhum "
echo ""
#Condicionais com o case, a variavel SHELLUSER receberá um novo valor dependendo da opção escolhida no menu
read -p "Selecione uma das opções: " SHELLUSER

	case $SHELLUSER in
			1)
				SHELLUSER=$(usermod -s /bin/sh $USUARIO)
				;;
			2)
				SHELLUSER=$(usermod -s /bin/dash $USUARIO)
				;;
			3)
				SHELLUSER=$(usermod -s /bin/bash $USUARIO)
				;;
			4)
				SHELLUSER=$(usermod -s /bin/rbash $USUARIO)
				;;
			5)
				SHELLUSER=$(usermod -s /bin/ksh $USUARIO)
				;;
			6)
				SHELLUSER=$(usermod -s /bin/zsh $USUARIO)
				;;
			7)
				SHELLUSER=$(usermod -s /bin/false $USUARIO)
				;;
			*)
				echo "Opção Inválida!"
				;;
	esac

# Váriaveis SHELLUSER e HOMEUSER recebem novos valores
SHELLUSER=$(grep $USUARIO /etc/passwd | cut -d":" -f7)

if [ $HOMEUSER = S -o $HOMEUSER = s ] 
then

	HOMEUSER=$(grep $USUARIO /etc/passwd | cut -d":" -f6)


elif [ $HOMEUSER = N -o $HOMEUSER = n ]
then

	HOMEUSER="Não foi criado"

fi

#Criando o cabeçalho de saida com as variaveis declaradas no script
echo ""
echo -e "USUARIO\t\t       NOME\t\t        SHELL PADRÃO\t\t   HOME PADRÃO"
echo -e "$USUARIO\t\t$NOME\t\t$SHELLUSER\t\t$HOMEUSER"

#Recendo entrada para criação de senha para o novo usuário.
#Condicional, opção S ou s para criar ou N ou n para não criar, em branco é opção invalida, senha não será criada.
echo ""
read -p "Deseja cadastrar uma senha para o novo usuário criado? (S/n):" OPCAO

	if [ $OPCAO = S -o $OPCAO = s ]
	then
		passwd $USUARIO
	
	elif [ $OPCAO = N -o $OPCAO = n ] 
	then
		echo "Você optou por não cadastrar uma nova senha para o usuário $USUARIO"
	
	else
		echo "Opção Inválida! você deve escolher Sim ou Não"
	       	echo "Senha não cadastrada para o $USUARIO."	
		
	fi

#Finalizando o script ....
echo ""
echo "Operação Concluída!"
echo ""
