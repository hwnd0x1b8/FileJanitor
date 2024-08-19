#!/usr/bin/env bash
echo "File Janitor, 2024"
echo "Powered by Bash"

if [ $1 = "help" ]; then
    cat "file-janitor-help.txt"
elif [ $1 = "list" ]; then
    if [ -z $2 ]; then 
        echo "Listing files in the current directory"
        ls -1fA
    elif [ -f $2 ]; then
        echo "$2 is not a directory"
    elif [ ! -d $2 ]; then
        echo "$2 is not found"
    else
        echo "Listing files in $2"
        ls -1fA $2
    fi
elif [ $1 = "report" ]; then
    if [ -z $2 ]; then 
        echo "The current directory contains:"
        echo "$(find -name "*.tmp" -maxdepth 1 -type f | wc -l) tmp file(s), with total size of $(find -name "*.tmp" -maxdepth 1 -type f -exec du -b {} + | awk '{total += $1} END {if (NR == 0) print 0; else print total}') bytes"
        echo "$(find -name "*.log" -maxdepth 1 -type f | wc -l) log file(s), with total size of $(find -name "*.log" -maxdepth 1 -type f -exec du -b {} + | awk '{total += $1} END {if (NR == 0) print 0; else print total}') bytes"
        echo "$(find -name "*.py" -maxdepth 1 -type f | wc -l) py file(s), with total size of $(find -name "*.py" -maxdepth 1 -type f -exec du -b {} + | awk '{total += $1} END {if (NR == 0) print 0; else print total}') bytes"
    elif [ -f $2 ]; then
        echo "$2 is not a directory"
    elif [ ! -d $2 ]; then
        echo "$2 is not found"
    else
        echo "$2 contains:"
        echo "$(find $2 -name "*.tmp" -maxdepth 1 -type f | wc -l) tmp file(s), with total size of $(find $2 -name "*.tmp" -maxdepth 1 -type f -exec du -b {} + | awk '{total += $1} END {if (NR == 0) print 0; else print total}') bytes"
        echo "$(find $2 -name "*.log" -maxdepth 1 -type f | wc -l) log file(s), with total size of $(find $2 -name "*.log" -maxdepth 1 -type f -exec du -b {} + | awk '{total += $1} END {if (NR == 0) print 0; else print total}') bytes"
        echo "$(find $2 -name "*.py" -maxdepth 1 -type f | wc -l) py file(s), with total size of $(find $2 -name "*.py" -maxdepth 1 -type f -exec du -b {} + | awk '{total += $1} END {if (NR == 0) print 0; else print total}') bytes"
    fi
elif [ $1 = "clean" ]; then
    if [ -z $2 ]; then 
        echo "Cleaning the current directory..."
        echo "Deleting old log files...  done! $(find -name "*.log" -maxdepth 1 -type f -mtime +2 | wc -l) files have been deleted"
        find -name "*.log" -maxdepth 1 -type f -mtime +2 -delete
        echo "Deleting temporary files...  done! $(find -name "*.tmp" -maxdepth 1 -type f | wc -l) files have been deleted"
        find -name "*.tmp" -maxdepth 1 -type f -delete
        echo "Moving python files...  done! $(find -name "*.py" -maxdepth 1 -type f | wc -l) files have been moved"
        PY_FILES_COUNT=$(find -name "*.py" -maxdepth 1 -type f | wc -l)
        if [ $PY_FILES_COUNT -ne 0 ]; then
            if [ ! -d "python_scripts" ]; then
                mkdir python_scripts
            fi
        fi
        mv $(find -name "*.py" -maxdepth 1 -type f) python_scripts

        echo "Clean up of the current directory is complete!"
    elif [ -f $2 ]; then
        echo "$2 is not a directory"
    elif [ ! -d $2 ]; then
        echo "$2 is not found"
    else
        echo "Cleaning $2..."
        echo "Deleting old log files...  done! $(find $2 -name "*.log" -maxdepth 1 -type f -mtime +2 | wc -l) files have been deleted"
        find $2 -name "*.log" -maxdepth 1 -type f -mtime +2 -delete
        echo "Deleting temporary files...  done! $(find $2 -name "*.tmp" -maxdepth 1 -type f | wc -l) files have been deleted"
        find $2 -name "*.tmp" -maxdepth 1 -type f -delete
        echo "Moving python files...  done! $(find $2 -name "*.py" -maxdepth 1 -type f | wc -l) files have been moved"
        PY_FILES_COUNT=$(find $2 -name "*.py" -maxdepth 1 -type f | wc -l)
        if [ $PY_FILES_COUNT -ne 0 ]; then
            if [ ! -d $2/python_scripts ]; then
                mkdir $2/python_scripts
            fi
        fi
        mv $(find $2 -name "*.py" -maxdepth 1 -type f) $2/python_scripts

        echo "Clean up of $2 is complete!"
    fi
else
    echo "Type file-janitor.sh help to see available options"
fi
