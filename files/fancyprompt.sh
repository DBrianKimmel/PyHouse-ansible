# add to .bashrc
# format: |current time|user (white: normal, red: root)@hostname (green: last command successful, red: error occurred):[current folder]-(num files and total size)-Cores: (num active cores) at (cpu temperature)>
# CPU readings thanks to DietPi (/DietPi/dietpi/dietpi-cpuinfo)
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
    for ((i=0; i<${#aFP_TEMPERATURE[@]}; i++)); do
        if [ -f "${aFP_TEMPERATURE[$i]}" ]; then
            CPU_TEMP_CURRENT=$(cat "${aFP_TEMPERATURE[$i]}")
            # - Some devices (pine) provide 2 digit output, some provide a 5 digit ouput.
            #       So, If the value is over 1000, we can assume it needs converting to 1'c
            if (( $CPU_TEMP_CURRENT >= 1000 )); then
                CPU_TEMP_CURRENT=$( echo -e "$CPU_TEMP_CURRENT" | awk '{print $1/1000}' | xargs printf "%0.0f" )
            fi
            if (( $CPU_TEMP_CURRENT >= 70 )); then
                CPU_TEMP_PRINT="\e[91mWarning: $CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 60 )); then
                CPU_TEMP_PRINT="\e[38;5;202m$CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 50 )); then
                CPU_TEMP_PRINT="\e[93m$CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 40 )); then
                CPU_TEMP_PRINT="\e[92m$CPU_TEMP_CURRENT'c\e[0m"
            elif (( $CPU_TEMP_CURRENT >= 30 )); then
                CPU_TEMP_PRINT="\e[96m$CPU_TEMP_CURRENT'c\e[0m"
            else
                CPU_TEMP_PRINT="\e[96m$CPU_TEMP_CURRENT'c\e[0m"
            fi
            break
        fi
    done
}
Obtain_Cpu_Temp
DATETIME="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|"
if [ "`id -u`" -eq 0 ]; then
    COLORUSER="\[\e[1;31m\]\u\[\e[1;36m\]"
else
    COLORUSER="\[\e[1m\]\u\[\e[1;36m\]"
fi
FOLDER="\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\w]\[\033[m\]-\[\e[36;1m\](\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(LC_ALL=C /bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b)"
PS1="$DATETIME$COLORUSER\[\033[m\]@\[\e[1;36m\]\[\`if [[ \$? = "0" ]]; then echo '\e[32m\h\e[0m'; else echo '\e[31m\h\e[0m' ; fi\`\[\033[m\]-Cores: $ACTIVECORES at $CPU_TEMP_PRINT\e[32m> \[\e[0m\]"
### END DBK
