miCasa=`pwd`
ubicateEn="/home/salud/jenkinsMonitor/SCRIPTSALUD_V01R00F00_Alfa9/scripts/Log"

cd $ubicateEn
grep "jdbc/ATMINF" *.log | cut -d"|" -f1,4 | cut -d"." -f1,3 | sort -n | uniq -c | awk '{print $2 " --> " $3}'
cd $miCasa

