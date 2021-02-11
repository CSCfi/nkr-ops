#!/bin/bash

FILE=/var/log/messages
LINEFILE=/tmp/rems_error_track/line-track.txt
myPath=/tmp/rems_error_track

# This script restarts rems if it is not running properly
# Check that the messages file exists
# If the messages file exists but no line-track.txt file exists, create the file with the line number of the latest error msg and length of the messages file
if [ -r "$FILE" ] && [ ! -f /tmp/rems_error_track/line-track.txt ]
then
        latestError=$(grep -n -P '^(?=.*org.apache.lucene.index.IndexNotFoundException)(?=.*no segments)' "$FILE" | tail -n1 | cut -d: -f1)
        fileLength=$(wc -l < "$FILE")
        if [ $latestError > 0 ]
        then
            lineAndFileLength=$latestError" "$fileLength
            echo $lineAndFileLength >${myPath}/line-track.txt
            systemctl restart rems
        else
            latestError=0
            lineAndFileLength=$latestError" "$fileLength
            echo $lineAndFileLength >${myPath}/line-track.txt
        fi
# If the line-track.txt exists, update its content with the latest error line number
else
        fileLength=$(wc -l < "$FILE")
        lines=$( awk '{print $2}' /tmp/rems_error_track/line-track.txt )
        latestError=$(grep -n -P '^(?=.*org.apache.lucene.index.IndexNotFoundException)(?=.*no segments)' "$FILE" | tail -n1 | cut -d: -f1)
        # If the messages file has less lines that the number stored in line-track.txt, update error line number and file length
        if [ $fileLength -lt $lines ]
        then
            if [ $latestError > 0 ]
            then
                lineAndFileLength=$latestError" "$fileLength
                echo $lineAndFileLength >${myPath}/line-track.txt
                systemctl restart rems

            else
                latestError=0
                lineAndFileLength=$latestError" "$fileLength
                echo $lineAndFileLength >${myPath}/line-track.txt
                # Do not restart rems here, error line is empty and only file length is stored
            fi

        else
            lineNumber=$( awk '{print $1}' /tmp/rems_error_track/line-track.txt )
            lines=$( awk '{print $2}' /tmp/rems_error_track/line-track.txt )
            latestError=$(grep -n -P '^(?=.*org.apache.lucene.index.IndexNotFoundException)(?=.*no segments)' "$FILE" | tail -n1 | cut -d: -f1)
            fileLength=$(wc -l < "$FILE")
            # line number in line-track.txt file is less than latest error if there is a new error line after it
            if [ $lineNumber -lt $latestError ]
            then
                updatedLineNumber=$latestError
                lineAndFileLength=$updatedLineNumber" "$fileLength
                echo $lineAndFileLength >${myPath}/line-track.txt
                systemctl restart rems
            else
                updatedLineNumber=$lineNumber
                lineAndFileLength=$updatedLineNumber" "$fileLength
                echo $lineAndFileLength >${myPath}/line-track.txt
                # No need to restart, no new error lines found
            fi
        fi
fi

