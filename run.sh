#start backup database
echo "I am start make backup is take few minutes"
FILE=CopyBy.snaphot ;
FILE=${FILE%.*}` date --utc +%Y%m%d_%H%M%SZ `;
FILE=${FILE//_/-};
a="$(aws rds create-db-snapshot   --db-instance-identifier mssql-server   --db-snapshot-identifier $FILE --output=json)";

echo "It is information about backup. ";
echo "Let's wait while the backup is done..";
echo "I ask AWS about backup. ";
a=`aws rds describe-db-snapshots --db-snapshot-identifier $FILE --query "DBSnapshots[].Status" --output=text`;

while [ "$a" != "available" ]
	do
		echo "He said backup is creating. Okay, Lets wait 1 minute";
		sleep 60 &
		PID=$!
		while [ -d /proc/$PID ]
			do
				echo -ne '#'
			sleep 1
			done
		echo -e ""
		echo -e "I ask AWS about backup. "
		
		a=`aws rds describe-db-snapshots --db-snapshot-identifier $FILE  --query "DBSnapshots[].Status" --output=text`
	done
echo "Complete!!! Lets update project"
