func_create_user(){
md5_pass=`echo $1 | openssl passwd -1 -stdin`
fenc_dir="/usr/"$1
echo "MD5 del usuario $1 : $md5_pass"
useradd -s /bin/bash -m -d $fenc_dir -g db2iadm -c "$2"  -p $md5_pass $1

func_pintame_simple "Verificando"
func_verifica_usuario $1

func_pintame_simple "Haciendo que no caduque"
func_user_no_caduca $1
}

func_verifica_usuario(){
echo
cat /etc/passwd | grep "$1"":x"
echo 
}

func_crea_instancia(){
cd_actual=`pwd`
cd "$db2_path""instance"
./db2icrt -a server -u $1 $2
cd $cd_actual
}


func_crea_db2_das_usr(){
cd_actual=`pwd`
cd "$db2_path""instance"
./dascrt -u $1
cd $cd_actual
}

func_pintame(){
echo
echo "---------------------------------------------"
echo "$1"
echo "---------------------------------------------"
echo
}

func_pintame_simple(){
echo
echo "..........."
echo "$1"
echo "..........."
echo
}

func_user_no_caduca(){
chage -m 0 $1 ; chage -M -1 $1 ; chage -I -1 $1
chage -l $1

}

func_start_das_admin(){
su - $1 -c "db2admin start"
su - $1 -c "db2admin start"
}

func_arranca_instancia(){
su - $1 -c "db2 update database manager configuration using svcename DB2_$1"
su - $1 -c "db2set DB2COMM=tcpip"
su - $1 -c "db2 force application all; db2 terminate; db2stop"
su - $1 -c "db2start"
func_pintame_simple "Exponiendo como ha quedado el servicio en el dbm"
su - $1 -c "db2 get dbm cfg | grep SVCENAME"
func_pintame_simple "Exponiendo el puerto"
su - $1 -c "cat /etc/services | grep _""$1"

}

func_kingkong_ssh(){
su - $1 -c "mkdir .ssh"
#su - $1 -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAmxrXZrYSMzXHy9sMeLexLy4FXTdmQrrjj67HBx9GEkFgHvqhS5Oiw6lsns0xM0JGz4xtrZrn36eA5J1fIdrPr1rr8qI2G723GsBKOCuNTUzlmlPeC+V7qJ+iz3CC1iQKk6YB5EA0nfyPtCKXv3UbTuic/z96Cv8bSqf5pFSBc7KAJ8m999pIyzX6MREh2dnf3NuwIh8Y0MP8Ia/zisbTm/wws2Qu7IiI7JFnOVFIyf5wU93WKUPrI2R9b2CNBDxWkWXN5otgssDEA8H+LMHZBQIWc42B2ol6KJx7nzyMuUWMKoz5Kk6d34MOfpeIzyWV6QZHgIeClJkcUmc52OFKNQ== root@kingkong.scisb.corp' >> .ssh/authorized_keys"
su - $1 -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyEnE6LmTgxaI3gUYtj3VPEjvds5RoPCOVVFovcYac36y2Yb3hVCVpxXMJMQF8oG5Fz9eJ4+bvLQa4u1utJ+YK5SC8pTAuNaeuFufH7l/5rTJtj+hw0tnhSb487eJusiMH2i7wQ4kE5APv6zbcBQK4u2ugV2GJQ7xDPfJ8UvaBmGiPBOIB7gtFDSPd0NBTs8bd8tJ8EKrWdWixoLstRKMNL9n1q/L22/CqOyJAiGksz/+KH3eF7d9WuMfZGe4uST2GT/g9g+/DEbchwtPPPpK+s+zaq5/JGdJXaL15gS7eUnYo9saSRI9wPNvPdH3d+TWbWA+ABRLJPoep36FfY871Q== root@kingkong.scisb.corp' >> .ssh/authorized_keys"
su - $1 -c "ls -l ./.ssh"
}

func_main(){
func_pintame "Creando el usuario Fenc"
func_create_user $fenc_user_and_password $fenc_comentario
func_pintame "Creando el usuario de la instancia"
func_create_user $inst_user_and_password $inst_comentario
func_pintame "Creando la instancia"
func_crea_instancia $fenc_user_and_password $inst_user_and_password

if [ "$quiero_DAS" == "SIDAS" ] 
then
  func_pintame "Creando el usuario DAS en el s.o"
  func_create_user $das_user_and_password $das_comentario
  func_pintame "Estableciendo usuario DAS para db2: $das_user_and_password"
  func_crea_db2_das_usr $das_user_and_password
  func_pintame "Arracando el Administration Server con el usuario das $das_user_and_password "
  func_start_das_admin $das_user_and_password
else
  if [ "$quiero_DAS" == "NODAS" ] 
  then
     func_pintame "NO SE CREARA USUARIO DAS"
  fi
fi

func_pintame "Estableciendo confianza entre el usuario $inst_user_and_password y el root de KinKong"
func_kingkong_ssh $inst_user_and_password
func_pintame "Arrancando la instancia $inst_user_and_password "
func_arranca_instancia $inst_user_and_password
}
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#Parametros Modificables..... O NO
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#--datos de db2--
db2_path="/opt/IBM/db2/V9.7/"
#--Datos de usuario de la instancia--
inst_user_and_password="$1"
#--Datos del usuario Fenc --
fenc_user_and_password="$2"
#--Datos del usuario DAS (Solo puede haber un usuario DAS por sistema)--
quiero_DAS="$3"
das_user_and_password="dasdb2"

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#FIN Parametros Modificables
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


#main
inst_comentario="usuario propio de la instancia $inst_user_and_password"
fenc_comentario="usuario fenc de la instancia $inst_user_and_password"
das_comentario="Usuario DAS para este entorno"

if [[ $inst_user_and_password ]] && [[ $fenc_user_and_password ]] && [[  $quiero_DAS  ]]; then
	quien_soy=$(whoami)
	if [ $quien_soy = "root" ]; then
		echo 
        echo "OK"
        echo
		func_main
	else
	   echo
	   echo "Mal rollo: Este script solo puede ejecutarse desde root"
	   echo "y tu eres $quien_soy"
	   echo
	fi
else
    echo ""
    echo "Faltan parametros:"
    echo "sh script [usuario_de_la_instancia] [usuario_fenc_de_la_instancia] [SIDAS/NODAS]"
    echo "ejemplo:"
    echo "sh create_db2_inst.sh inst1 fenc1 SIDAS"
    echo "sh create_db2_inst.sh inst1 fenc1 NODAS"
    echo
    echo "SIDAS: crea y establece un usuario DAS"
    echo "NODAS: NO crea NI establece un usuario DAS"
    echo ""
fi