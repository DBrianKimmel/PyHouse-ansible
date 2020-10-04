# Name:    PyHouse-ansible/roles/install-basic-system/files/fancy-prompt.sh
# Author:  D. Brian Kimmel
# Created: 2018-07-19
# Updated: 2020-10-03
#
# This will 
#
# add to .bashrc
# |<Time>|<User>@<HostName>:<Current-Dir>
# <Time> = Current Time (light red)
# <User> = Logged in user (black bold = Normal user; Red = Root)
# <HostName> = Host Name (green = last command OK; red = error occurred)
# <Current-dir> = Current Directory ()

# format: :[current folder]-(num files and total size)-Cores: (num active cores) at (cpu temperature)>
# CPU readings thanks to DietPi (/DietPi/dietpi/dietpi-cpuinfo)

ESC="\033["
END="\]"
NORMAL="\033[m"
MAGENTA="\033[35m"
BRT_RED="\033[38;5;9m"
BRT_GREEN="\033[92m"
BRT_YELLOW="\033[93m"
BRT_CYAN="\033[96m"
BRT_WHITE="\033[97m"

# The celcius character
CEL=$'\xE2\x84\x83'

CPU_TEMP_CURRENT='Unknown'
CPU_TEMP_PRINT='Unknown'
ACTIVECORES=$(grep -c processor /proc/cpuinfo)

#Array to store possible locations for temp read.
aFP_TEMPERATURE=(
        '/sys/class/thermal/thermal_zone0/temp'
        '/sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/temp1_input'
        '/sys/class/hwmon/hwmon0/device/temp_label'
)

Obtain_Cpu_Temp(){
	for ((i=0; i<${#aFP_TEMPERATURE[@]}; i++))
	do
		if [ -f "${aFP_TEMPERATURE[$i]}" ]; then
			CPU_TEMP_CURRENT=$(cat "${aFP_TEMPERATURE[$i]}")
			# - Some devices (pine) provide 2 digit output, some provide a 5 digit ouput.
			#       So, If the value is over 1000, we can assume it needs converting to 1'c
			if (( $CPU_TEMP_CURRENT >= 1000 )); then
				CPU_TEMP_CURRENT=$( echo -e "$CPU_TEMP_CURRENT" | awk '{print $1/1000}' | xargs printf "%0.0f" )
            fi
            if (( $CPU_TEMP_CURRENT >= 70 )); then
				CPU_TEMP_PRINT="${BRT_RED}Warning: $CPU_TEMP_CURRENT'c${NORMAL}"
            elif (( $CPU_TEMP_CURRENT >= 60 )); then
				CPU_TEMP_PRINT="\e[38;5;202m$CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 50 )); then
				CPU_TEMP_PRINT="${BRT_YELLOW}$CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 40 )); then
				CPU_TEMP_PRINT="${BRT_GREEN}$CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 30 )); then
            	CPU_TEMP_PRINT="${BRT_CYAN}$CPU_TEMP_CURRENT${CEL}${NORMAL}"
            else
				CPU_TEMP_PRINT="${BRT_CYAN}$CPU_TEMP_CURRENT${CEL}${NORMAL}"
            fi
			break
		fi
	done
}

Obtain_Cpu_Temp

PS_TIME="${NORMAL}|${MAGENTA}\t${NORMAL}|"
PS_HOST="${BRT_GREEN}\h${NORMAL} "

if [ "`id -u`" -eq 0 ]; then
	PS_USER="${BRT_RED}\u${NORMAL}"
else
	PS_USER="${NORMAL}\u${NORMAL}"
fi

PS_CORES="  ${BRT_WHITE}${ACTIVECORES} Cores @ "

PS_TEMP="${PS_RANGE}${CPU_TEMP_CURRENT}${CEL}${ESC}0m${END}"

FOLDER="${ESC}0m${END}:${ESC}0m${END}${ESC}1;32m${END}[\w]${ESC}0m${END}-${ESC}36;1m${END}(\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(LC_ALL=C /bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b)"

PS1="${PS_TIME}${PS_USER}${BRT_WHITE}@${NORMAL} ${PS_HOST} ${PS_CORES} $CPU_TEMP_PRINT\e[32m> \[\e[0m\]"

### END DBK
