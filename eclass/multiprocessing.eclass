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

# @FUNCTION: bashpid
# @DESCRIPTION:
# Return the process id of the current sub shell.  This is to support bash
# versions older than 4.0 that lack $BASHPID support natively.  Simply do:
# echo ${BASHPID:-$(bashpid)}
#
# Note: Using this func in any other way than the one above is not supported.
bashpid() {
	# Running bashpid plainly will return incorrect results.  This func must
	# be run in a subshell of the current subshell to get the right pid.
	# i.e. This will show the wrong value:
	#   bashpid
	# But this will show the right value:
	#   (bashpid)
	sh -c 'echo ${PPID}'
}

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

# @FUNCTION: redirect_alloc_fd
# @USAGE: <var> <file> [redirection]
# @DESCRIPTION:
# Find a free fd and redirect the specified file via it.  Store the new
# fd in the specified variable.  Useful for the cases where we don't care
# about the exact fd #.
redirect_alloc_fd() {
	local var=$1 file=$2 redir=${3:-"<>"}

	# Make sure /dev/fd is sane on Linux hosts. #479656
	if [[ ! -L /dev/fd && ${CBUILD} == *linux* ]] ; then
		eerror "You're missing a /dev/fd symlink to /proc/self/fd."
		eerror "Please fix the symlink and check your boot scripts (udev/etc...)."
		die "/dev/fd is broken"
	fi

	if [[ $(( (BASH_VERSINFO[0] << 8) + BASH_VERSINFO[1] )) -ge $(( (4 << 8) + 1 )) ]] ; then
		# Newer bash provides this functionality.
		eval "exec {${var}}${redir}'${file}'"
	else
		# Need to provide the functionality ourselves.
		local fd=10
		while :; do
			# Make sure the fd isn't open.  It could be a char device,
			# or a symlink (possibly broken) to something else.
			if [[ ! -e /dev/fd/${fd} ]] && [[ ! -L /dev/fd/${fd} ]] ; then
				eval "exec ${fd}${redir}'${file}'" && break
			fi
			[[ ${fd} -gt 1024 ]] && die 'could not locate a free temp fd !?'
			: $(( ++fd ))
		done
		: $(( ${var} = fd ))
	fi
}

fi
