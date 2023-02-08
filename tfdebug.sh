#/usr/bin/env bash

# Terraform On/Off Debug Function
function tfdebug()
{
  # Checking if $1 is provided.
  if [ "${1}" ]; then
    # If $1 is help, provide list of usable options.
    if [ "${1,,}" = "help" ]; then # Converts $1 to lowercase for check.
      echo -e "Available Log Levels:\nTRACE\nDEBUG\nINFO\nWARN\nERROR\n"
      echo "Default option: DEBUG"
      return 0 # Exits the function.
    # If $1 is off, disable Terraform Logging.
    elif [ "${1,,}" = "off" ]; then # Converts $1 to lowercase for check.
      echo -e "Disabling Terraform logging."
      unset TF_LOG
      unset TF_LOG_PATH
      return 0 # Exits the function.
    fi
  # Checking if $1 is a valid option, if not providing available options.
    case "${1^^}" in # Converts $1 to uppercase for check.
      TRACE)
        logLevel="TRACE"
        ;;
      DEBUG)
        logLevel="DEBUG"
        ;;
      INFO)
        logLevel="INFO"
        ;;
      WARN)
        logLevel="WARN"
        ;;
      ERROR)
        logLevel="ERROR"
        ;;
      *)
        # If a invalid option was supplied, prompt the user for what option they would like to set.
        echo "Invalid option provided, please select one of the following:"
        select OPTION in TRACE DEBUG INFO WARN ERROR; do
          logLevel="${OPTION}"
          echo "Selected Option: ${logLevel}"
          break
        done
        ;;
    esac
  else # Default Log Level if $1 is not provided.
      logLevel="DEBUG"
  fi

  # If TF_LOG is already set and does matches provided log level, disable.
  if [ -n "${TF_LOG}" -a "${TF_LOG}" = "${logLevel}" ]; then
    echo "Disabling Terraform logging, log level: ${TF_LOG}"
    unset TF_LOG
    unset TF_LOG_PATH
  else # If it is not set or does not match current Log Level, sets selected Log Level.
    echo "Setting Terraform logging, Loglevel: ${logLevel}"
    echo "Log File: $(readlink -f ./.terraform_${logLevel}.log)"
    export TF_LOG="${logLevel}"
    export TF_LOG_PATH="./.terraform_${logLevel}.log"
  fi
  return 0
}

# Check if script is sourced or directly executed:
# If sourced, setup Bash Completion
if $(return >/dev/null 2>$1); then
  complete -W tfdebug
else # If ran directly, pass arguments to function
  tfdebug "${@}"
fi