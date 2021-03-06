#!/bin/bash

###################################################
#
# Author: ndom91
#
# Desc: tars system and uploads to rclone mega
#
###################################################

###################
# VARIABLES
###################

DATE=$(date "+%d%m%y")
TIME=$(date +%b-%d-%y)
FILENAME="backup-configs-openpi-$TIME.tar.gz"
FILENAME2="backup-openhab2-$TIME.zip"
DESDIR=/home/pi/Backups

echo "########################################"
echo "#"
echo "#      Backup open-pi Daily"
echo "#"
echo "#     "$(date)
echo "#"
echo "#          Author: ndom91"
echo "#"
echo "########################################"
echo ""

echo "Starting backup..."

##########################################################
# TAR BALL ALL THE DIRS!
##########################################################

mkdir $DESDIR/$DATE
/usr/share/openhab2/runtime/bin/backup $DESDIR/$DATE/$FILENAME2
cd $DESDIR/$DATE
/usr/local/bin/pihole -a -t
cp /etc/default/cloudflared $DESDIR/$DATE

tar \
-cvpzf \
$DESDIR/$FILENAME \
$DESDIR/$DATE >> /dev/null 2>&1

####################################
# CLEAN UP
####################################

echo ""

echo "[*] Backup complete. "
# echo "[*] Now to mega:/ndoX_backup/open-pi/"

# /usr/bin/rclone move --config /home/pi/.config/rclone/rclone.conf --log-file /home/pi/rclonelogs/backup-$TIME.log $DESDIR/$FILENAME mega:ndoX_backup/open-pi >> /dev/null

# echo ""

# echo "[*] Move complete!"
# echo ""
echo "[*] Cleaning up!"

# echo ""
# echo "[*] Checking if $FILENAME made it to NDO_Backup successfully..."
# echo ""

# if [ -f /mnt/NDO_Backup/pi_backups/open-pi/$FILENAME ]; then
	# echo "[*] File succesfully transfered!"
	# echo "[*] Clean up can continue..."
	# echo "$ rm "$DESDIR"/"$FILENAME
	# /usr/bin/rclone delete --config /home/pi/.config/rclone/rclone.conf --min-age 7d mega:ndoX_backup/open-pi
# else
	# echo ""
	# echo "[*] File UNSUCCESSFULLY transfered to NDO_Backup - manually check!"
	# echo "[*] NOT deleting $DESDIR/$DATE !!! "
# fi

# rm -r $DESDIR/$DATE
find /mnt/NDO_Backup/pi_backups/open-pi -type f -mtime +6 -delete

echo ""

find /home/pi/Backups -iname "*.tar.gz" -mtime +4 -type f -delete
find /home/pi/Backups -mtime +1 -type d -delete

echo "[*] Clean up complete"

echo ""

FILESIZE=$(/usr/bin/rclone --config /home/pi/.config/rclone/rclone.conf ls mega:/ndoX_backup/open-pi/backup-configs-openpi-$TIME.tar.gz | awk '{print $1}')
FILESIZEa=$(/usr/bin/bc -l <<< "scale=2; $FILESIZE / 1048576")

echo "[*] Backup complete!"
echo ""
echo "########################################"
echo "#"
echo "#        size: "$FILESIZEa "mb"
echo "#"
echo "#        "$(date)
echo "#"
echo "########################################"

