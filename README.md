# maracoScriptsTools
utilidades 

#create_db2_inst.sh
    Este script, esta pensado para ejecutar sobre nuevos entornos, pero haciendo pequeños retoques puede usarse para crear instancias sobre entornos ya usados.

    El script debe ejecutarse con root.

    El scritp hace esto:

    1. Crea el usuario Fenc para db2 en el s.o (nunca expira)
    2. Crea el usuario de la instancia en el s.o (nunca expira)
    3. Crea el usuario DAS en el S.O (nunca expira)
    4. Crea la instancia
    5. Establece usuario das como administrador del sistema
    6. Arranca el Administration Server
    7. Establece confianza ssh entre el usuario de la instancia y kingkong
    8. Arranca la instancia.
    Ala!

    script adjunto.

    Para usar el script:

    Conectarse a la maquina en cuestión.
    Si no existe crear un directorio scripts.
    Meter el script en el directorio.
    Entrar con root
    forma de Ejecutarlo
    [root@OCLDB2D208 script]# sh create_db2_inst.sh

    Faltan parametros:
    sh script [usuario_de_la_instancia] [usuario_fenc_de_la_instancia] [SIDAS/NODAS]
    ejemplo:
    sh create_db2_inst.sh inst1 fenc1 SIDAS
    sh create_db2_inst.sh inst1 fenc1 NODAS

    SIDAS: crea y establece un usuario DAS
    NODAS: NO crea NI establece un usuario DAS
    Rock and Rooooollllll
