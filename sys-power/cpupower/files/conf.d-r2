# /etc/conf.d/cpupower: config file for /etc/init.d/cpupower

# Options when starting cpufreq (given to the `cpupower` program)
# Possible options are:
# -g --governor <GOV> (ie: ondemand, performance, or powersave)
# -d --min <FREQ> (ie: 1000MHz)
# -u --max <FREQ> (ie: 2000MHz)
# -f --freq <FREQ> (requires userspace governor, this *can not* be combined with
#                   with any other parameters).
# Frequencies can be passed in Hz, kHz (default), MHz, GHz, or THz by postfixing the
# value with  the  wanted  unit name, without any space.
# (frequency in kHz =^ Hz * 0.001 =^ MHz * 1000 =^ GHz * 1000000).

START_OPTS="--governor ondemand"

# Options when stopping cpufreq (given to the `cpupower` program)
# This option can be used to change governer on stop. Leaving it empty will ensure
# the governer remains on the one provided above.
STOP_OPTS=""

# Extra settings to write to sysfs cpufreq values.
#
# up_threshold: threshold for stepping up frequency, where the value represents
# the percentage of cpu load. 
#
# down_threshold: threshold for stepping down frequency, where the value
# represents the percentage of cpu load.
#
# sampling_down_factor: determines how frequently the governor polls the cpu, a
# value greater than 1 improves performance by reducing the polling when the
# load is high. This tunable has no effect on behavior at lower CPU frequencies.
#
# ignore_nice_load: when set to '1' the processes that are run with a 'nice'
# value will not count in the usage calculation.

#SYSFS_EXTRA="ondemand/ignore_nice_load=1 ondemand/up_threshold=75 ondemand/sampling_down_factor=10"
