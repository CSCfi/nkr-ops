#!/bin/bash
# This script restarts REMS if it is not running properly

LOG_FILE=/var/log/messages
LINEFILE=/tmp/rems_error_track/line-track.txt
ERROR='^(?=.*org.apache.lucene.index.IndexNotFoundException)(?=.*no segments)'

# Check that the messages file exists
# If the messages file exists but no line-track.txt file exists, create the file with the line number of the latest error msg and length of the messages file
if [ -r "$LOG_FILE" ] && [ ! -f "$LINEFILE" ]
then
        lastErrorLine=$(grep -n -P "$ERROR" "$LOG_FILE" | tail -n1 | cut -d: -f1)
        fileLength=$(wc -l < "$LOG_FILE")
        if [ $latestError > 0 ]
        then
            lineAndFileLength=$lastErrorLine" "$fileLength
            echo $lineAndFileLength >$LINEFILE
            systemctl restart rems
        else
            lastErrorLine=0
            lineAndFileLength=$lastErrorLine" "$fileLength
            echo $lineAndFileLength >$LINEFILE
        fi
# If the line-track.txt exists, update its content with the latest error line number
else
        fileLength=$(wc -l < "$LOG_FILE")
        oldFileLength=$( awk '{print $2}' "$LINEFILE" )
        lastErrorLine=$(grep -n -P "$ERROR" "$LOG_FILE" | tail -n1 | cut -d: -f1)
        # If the messages file has less lines that the number stored in line-track.txt, update error line number and file length
        if [ $fileLength -lt $oldFileLength ]
        then
            if [ $lastErrorLine > 0 ]
            then
                lineAndFileLength=$lastErrorLine" "$fileLength
                echo $lineAndFileLength >$LINEFILE
                systemctl restart rems

            else
                lastErrorLine=0
                lineAndFileLength=$lastErrorLine" "$fileLength
                echo $lineAndFileLength >$LINEFILE
                # Do not restart rems here, error line is empty and only file length is stored
            fi

        else
            oldErrorLine=$( awk '{print $1}' "$LINEFILE" )
            lastErrorLine=$(grep -n -P "$ERROR" "$LOG_FILE" | tail -n1 | cut -d: -f1)
            fileLength=$(wc -l < "$LOG_FILE")
            # line number in line-track.txt file is less than latest error if there is a new error line after it
            if [ $oldErrorLine -lt $lastErrorLine ]
            then
                updatedLineNumber=$lastErrorLine
                lineAndFileLength=$updatedLineNumber" "$fileLength
                echo $lineAndFileLength >$LINEFILE
                systemctl restart rems
            else
                lineAndFileLength=$oldErrorLine" "$fileLength
                echo $lineAndFileLength >$LINEFILE
                # No need to restart, no new error lines found
            fi
        fi
fi

