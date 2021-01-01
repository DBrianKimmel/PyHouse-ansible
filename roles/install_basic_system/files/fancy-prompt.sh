# Name:    PyHouse-ansible/roles/install-basic-system/files/fancy-prompt.sh
# Author:  D. Brian Kimmel
# Created: 2018-07-19
# Updated: 2021-01-01

NORMAL="\[\e[0m\]"
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
MAGENTA="\[\e[0;35m\]"
CYAN="\[\e[0;36m\]"
WHITE="\[\e[0;37m\]"
BRT_RED="\[\e[1;31m\]"
BRT_GREEN="\[\e[1;32m\]"
BRT_YELLOW="\[\e[1;33m\]"
BRT_BLUE="\[\e[94m\]"
BRT_CYAN="\[\e[96m\]"
BRT_WHITE="\[\e[97m\]"

TEMP=9876.543
ACTIVECORES=$(grep -c processor /proc/cpuinfo)

# The celcius character
PS_DEGREE=$( echo -e "\xE2\x84\x83C${NORMAL}" )
PS_AT="${BRT_WHITE}@"
PS_CORES="${BRT_WHITE}${ACTIVECORES}-Cores@"
PS_TIME="${NORMAL}|${MAGENTA}\t${NORMAL}|"
if [ "`id -u`" -eq 0 ]; then
	PS_USER="${BRT_RED}\u${NORMAL}"
else
	PS_USER="${GREEN}\u${NORMAL}"
fi
PS_HOST="${BRT_GREEN}\h${NORMAL}:"
PS_FOLDER="${NORMAL}:${BRT_GREEN}[\w]${NORMAL}-${BRT_CYAN}(\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(LC_ALL=C /bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b)"

#######################################
# Classify the temp
#######################################
classify_temp () {
	PS_RANGE="Unclassified: "
    if   (( ${TEMP} >= 70 )); then
		PS_RANGE="${BRT_RED}Danger: "
    elif (( ${TEMP} >= 60 )); then
		PS_RANGE="${RED}Warning: "
    elif (( ${TEMP} >= 50 )); then
		PS_RANGE="${BRT_YELLOW}Caution: "
    elif (( ${TEMP} >= 40 )); then
		PS_RANGE="${BRT_GREEN}Good: "
    elif (( ${TEMP} >= 30 )); then
    	PS_RANGE="${BRT_CYAN}Normal: "
    else
    	PS_RANGE="${WITE}Guess: "
    fi
}
#######################################
# Normalize the temperature
# - Some devices (pine) provide 2 digit output, some provide a 5 digit ouput.
#   If the value is over 1000, we can assume it needs converting.
#######################################
function normalize_temp () {
	if (( ${TEMP} >= 1000 )); then
		TEMP=$( echo -e "${TEMP}" | awk '{print $1/1000}' | xargs printf "%0.0f" )
    fi
}
#Array to store possible locations for temp read.
aFP_TEMPERATURE=(
    '/sys/class/thermal/thermal_zone0/temp'
    '/sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/temp1_input'
    '/sys/class/hwmon/hwmon0/device/temp_label'
)
#######################################
# Obtain the CPU temperature
# GLOBALS:
#   TEMP
#######################################
function get_temp () {
	TEMP=1
	for (( ix=0; i<${#aFP_TEMPERATURE[@]}; ix++ )); do
		if [ -f "${aFP_TEMPERATURE[$ix]}" ]; then
			TEMP=$(cat "${aFP_TEMPERATURE[$ix]}")
			normalize_temp
			classify_temp
			PS_TEMP="${PS_RANGE}${TEMP}${PS_DEGREE}"
			break
		fi
	done
}
function build_prompt () {
	get_temp
	PS1="${PS_TIME}${PS_USER}${PS_AT}${PS_HOST}${PS_CORES}${PS_TEMP}${PS_FOLDER}${NORMAL}> "
}

PROMPT_COMMAND=build_prompt

### END DBK
