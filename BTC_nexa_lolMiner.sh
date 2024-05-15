#!/bin/bash
echo "Starting Script"

ALGO=NEXA
POOL=stratum+ssl://nexapow.unmineable.com:4444
WALLET=BTC:bc1qyvtmg28awpnajk2rjkrtr6xvmyqr6yv86l383xd0dy6zj6x5lt7qahsnhh.RIG#wl9w-b25y
APIP=8020
COFF=255
CCLK=2505
MOFF=2400
PL=250
DEVICES=NVIDIA
TEMP_START=30
TEMP_STOP=70
TEMP_MODE=edge
echo "Variables Set"
echo "Veiw miner output = screen -r miner_nexa"
echo "Exit miner output = (Ctrl + A), and then D"
echo "Stop miner = screen -S miner_nexa -X quit"

#Get the full pathe to the script
FILE_PATH="$(pwd)/$(basename "$0")"
echo $FILE_PATH
# Command to add cron job
CRON_JOB="@reboot $FILE_PATH"

# Check if the cron job is already present
if crontab -l | grep -q "$CRON_JOB"; then
    echo "Cron job already exists. Skipping addition."
else
    # Add the cron job
    (crontab -l ; echo "$CRON_JOB") | crontab -
    echo "Cron job added successfully."
fi

# Start the miner in a detached screen session
/usr/bin/screen -dmS $ALGO ./lolMiner \
        --algo $ALGO \
        --pool $POOL \
        --user $WALLET \
        --apiport $APIP \
        --coff $COFF \
        --cclk $CCLK \
        --moff $MOFF \
        --pl $PL \
        --devices $DEVICES \
        --tstart $TEMP_START \
        --tstop $TEMP_STOP \
        --tmode $TEMP_MODE

# Check if the miner screen session is still active
while /usr/bin/screen -list | grep -q $ALGO; do
    sleep 5
done

# Remove from crontab
(crontab -l | grep -v "$FILE_PATH" ) | crontab -
