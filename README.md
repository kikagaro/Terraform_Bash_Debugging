# Terraform_Bash_Debugging
Over engineered script to enable or disable Terraform Debugging on Bash.

## Local Execution Example:
```
./tfdebug.sh 
```
## Source setup:
Add to your .bashrc to source.
```
TFDEBUG_FILE="/PATH/TO/tfdebug.sh"
if [ -f "${TFDEBUG_FILE}" ]; then # If the script exist
  . "${TFDEBUG_FILE}"; fi
```