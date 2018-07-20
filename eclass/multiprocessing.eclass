# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: multiprocessing.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Brian Harring <ferringb@gentoo.org>
# Mike Frysinger <vapier@gentoo.org>
# @BLURB: multiprocessing helper functions
# @DESCRIPTION:
# The multiprocessing eclass contains a suite of utility functions
# that could be helpful to controlling parallel multiple job execution.
# The most common use is processing MAKEOPTS in order to obtain job
# count.
#
# @EXAMPLE:
#
# @CODE
# src_compile() {
#   # custom build system that does not support most of MAKEOPTS
#   ./mybs -j$(makeopts_jobs)
# }
# @CODE

if [[ -z ${_MULTIPROCESSING_ECLASS} ]]; then
_MULTIPROCESSING_ECLASS=1

# @FUNCTION: get_nproc
# @USAGE: [${fallback:-1}]
# @DESCRIPTION:
# Attempt to figure out the number of processing units available.
# If the value can not be determined, prints the provided fallback
# instead. If no fallback is provided, defaults to 1.
get_nproc() {
	local nproc

	# GNU
	if type -P nproc &>/dev/null; then
		nproc=$(nproc)
	fi

	# BSD
	if [[ -z ${nproc} ]] && type -P sysctl &>/dev/null; then
		nproc=$(sysctl -n hw.ncpu 2>/dev/null)
	fi

	# fallback to python2.6+
	# note: this may fail (raise NotImplementedError)
	if [[ -z ${nproc} ]] && type -P python &>/dev/null; then
		nproc=$(python -c 'import multiprocessing; print(multiprocessing.cpu_count());' 2>/dev/null)
	fi

	if [[ -n ${nproc} ]]; then
		echo "${nproc}"
	else
		echo "${1:-1}"
	fi
}

# @FUNCTION: makeopts_jobs
# @USAGE: [${MAKEOPTS}] [${inf:-999}]
# @DESCRIPTION:
# Searches the arguments (defaults to ${MAKEOPTS}) and extracts the jobs number
# specified therein.  Useful for running non-make tools in parallel too.
# i.e. if the user has MAKEOPTS=-j9, this will echo "9" -- we can't return the
# number as bash normalizes it to [0, 255].  If the flags haven't specified a
# -j flag, then "1" is shown as that is the default `make` uses.  Since there's
# no way to represent infinity, we return ${inf} (defaults to 999) if the user
# has -j without a number.
makeopts_jobs() {
	[[ $# -eq 0 ]] && set -- "${MAKEOPTS}"
	# This assumes the first .* will be more greedy than the second .*
	# since POSIX doesn't specify a non-greedy match (i.e. ".*?").
	local jobs=$(echo " $* " | sed -r -n \
		-e 's:.*[[:space:]](-[a-z]*j|--jobs[=[:space:]])[[:space:]]*([0-9]+).*:\2:p' \
		-e "s:.*[[:space:]](-[a-z]*j|--jobs)[[:space:]].*:${2:-999}:p")
	echo ${jobs:-1}
}

# @FUNCTION: makeopts_loadavg
# @USAGE: [${MAKEOPTS}] [${inf:-999}]
# @DESCRIPTION:
# Searches the arguments (defaults to ${MAKEOPTS}) and extracts the value set
# for load-average. For make and ninja based builds this will mean new jobs are
# not only limited by the jobs-value, but also by the current load - which might
# get excessive due to I/O and not just due to CPU load.
# Be aware that the returned number might be a floating-point number. Test
# whether your software supports that.
# If no limit is specified or --load-average is used without a number, ${inf}
# (defaults to 999) is returned.
makeopts_loadavg() {
	[[ $# -eq 0 ]] && set -- "${MAKEOPTS}"
	# This assumes the first .* will be more greedy than the second .*
	# since POSIX doesn't specify a non-greedy match (i.e. ".*?").
	local lavg=$(echo " $* " | sed -r -n \
		-e 's:.*[[:space:]](-[a-z]*l|--(load-average|max-load)[=[:space:]])[[:space:]]*([0-9]+(\.[0-9]+)?)[[:space:]].*:\3:p' \
		-e "s:.*[[:space:]](-[a-z]*l|--(load-average|max-load))[[:space:]].*:${2:-999}:p")
	# Default to ${inf} since the default is to not use a load limit.
	echo ${lavg:-${2:-999}}
}

fi
