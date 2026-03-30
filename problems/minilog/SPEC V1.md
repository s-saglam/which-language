PROJECT:Mini-log
VERSION:v1
DATE:13.03.2026

==============================
OVERVIEW
==============================

Mini-log is a CLI tool.
It gets logs in a plain text file.
Support reading,analyzing,statistic
and filtering features for logs.

All data is persisted in directory 
named .Mini-log/ in current state.

==============================
COMMAND
==============================

---logs---
Usage:python Mini-log.py logs <logfile>
Return all logs count

---count---
Usage:python Mini-log.py count <LEVEL> <logfile>
return count of the log level 

---filter---
Usage:python Mini-log.py filter <LEVEL> <logfile>
Filter the chosen log level and return them
 ERROR Database connection failed
 ERROR Timeout

---find---
Usage:python Mini-log.py find <keyword> <logfile>
search for selected word in logs 
 2025-11-10 10:35:02 ERROR Database connection failed

==============================
DATA FORMAT
==============================

FILE: .Mini-log/files.dat
FORMAT:One line for one task,seperated by ' ' char.
       TIMESTAMP LEVEL MESSAGE
EXAMPLE:
    2025-11-10 10:35:02 ERROR Database connection failed
TIMESTAMP FORMAT:
    YYYY-MM-DD HH:MM:SS 
SUPPORTED LOG LEVELS:
    INFO,WARNING,ERROR,DEBUG

==============================
ERROR HANDLING
==============================

-Missing file name:print file name is missing
-File not found:print Log file not found
-Invalid command:print "Unknown command <command>"
-Missing arguments: print "Usage: python Mini-log.py <command> [args]"

