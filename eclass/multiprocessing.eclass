# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: multiprocessing.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Brian Harring <ferringb@gentoo.org>
# Mike Frysinger <vapier@gentoo.org>
# @BLURB: parallelization with bash (wtf?)
# @DESCRIPTION:
# The multiprocessing eclass contains a suite of functions that allow ebuilds
# to quickly run things in parallel using shell code.
#
# It has two modes: pre-fork and post-fork.  If you don't want to dive into any
# more nuts & bolts, just use the pre-fork mode.  For main threads that mostly
# spawn children and then wait for them to finish, use the pre-fork mode.  For
# main threads that do a bit of processing themselves, use the post-fork mode.
# You may mix & match them for longer computation loops.
# @EXAMPLE:
#
# @CODE
# # First initialize things:
# multijob_init
#
# # Then hash a bunch of files in parallel:
# for n in {0..20} ; do
# 	multijob_child_init md5sum data.${n} > data.${n}
# done
#
# # Then wait for all the children to finish:
# multijob_finish
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

# @FUNCTION: makeopts_jobs
# @USAGE: [${MAKEOPTS}]
# @DESCRIPTION:
# Searches the arguments (defaults to ${MAKEOPTS}) and extracts the jobs number
# specified therein.  Useful for running non-make tools in parallel too.
# i.e. if the user has MAKEOPTS=-j9, this will echo "9" -- we can't return the
# number as bash normalizes it to [0, 255].  If the flags haven't specified a
# -j flag, then "1" is shown as that is the default `make` uses.  Since there's
# no way to represent infinity, we return 999 if the user has -j without a number.
makeopts_jobs() {
	[[ $# -eq 0 ]] && set -- ${MAKEOPTS}
	# This assumes the first .* will be more greedy than the second .*
	# since POSIX doesn't specify a non-greedy match (i.e. ".*?").
	local jobs=$(echo " $* " | sed -r -n \
		-e 's:.*[[:space:]](-j|--jobs[=[:space:]])[[:space:]]*([0-9]+).*:\2:p' \
		-e 's:.*[[:space:]](-j|--jobs)[[:space:]].*:999:p')
	echo ${jobs:-1}
}

# @FUNCTION: makeopts_loadavg
# @USAGE: [${MAKEOPTS}]
# @DESCRIPTION:
# Searches the arguments (defaults to ${MAKEOPTS}) and extracts the value set
# for load-average. For make and ninja based builds this will mean new jobs are
# not only limited by the jobs-value, but also by the current load - which might
# get excessive due to I/O and not just due to CPU load.
# Be aware that the returned number might be a floating-point number. Test
# whether your software supports that.
makeopts_loadavg() {
	[[ $# -eq 0 ]] && set -- ${MAKEOPTS}
	# This assumes the first .* will be more greedy than the second .*
	# since POSIX doesn't specify a non-greedy match (i.e. ".*?").
	local lavg=$(echo " $* " | sed -r -n \
		-e 's:.*[[:space:]](-l|--(load-average|max-load)[=[:space:]])[[:space:]]*([0-9]+|[0-9]+\.[0-9]+).*:\3:p' \
		-e 's:.*[[:space:]](-l|--(load-average|max-load))[[:space:]].*:999:p')
	# Default to 999 since the default is to not use a load limit.
	echo ${lavg:-999}
}

# @FUNCTION: multijob_init
# @USAGE: [${MAKEOPTS}]
# @DESCRIPTION:
# Setup the environment for executing code in parallel.
# You must call this before any other multijob function.
multijob_init() {
	# When something goes wrong, try to wait for all the children so we
	# don't leave any zombies around.
	has wait ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" wait "

	# Setup a pipe for children to write their pids to when they finish.
	# We have to allocate two fd's because POSIX has undefined behavior
	# when you open a FIFO for simultaneous read/write. #487056
	local pipe="${T}/multijob.pipe"
	mkfifo -m 600 "${pipe}"
	redirect_alloc_fd mj_write_fd "${pipe}"
	redirect_alloc_fd mj_read_fd "${pipe}"
	rm -f "${pipe}"

	# See how many children we can fork based on the user's settings.
	mj_max_jobs=$(makeopts_jobs "$@")
	mj_num_jobs=0
}

# @FUNCTION: multijob_child_init
# @USAGE: [--pre|--post] [command to run in background]
# @DESCRIPTION:
# This function has two forms.  You can use it to execute a simple command
# in the background (and it takes care of everything else), or you must
# call this first thing in your forked child process.
#
# The --pre/--post options allow you to select the child generation mode.
#
# @CODE
# # 1st form: pass the command line as arguments:
# multijob_child_init ls /dev
# # Or if you want to use pre/post fork modes:
# multijob_child_init --pre ls /dev
# multijob_child_init --post ls /dev
#
# # 2nd form: execute multiple stuff in the background (post fork):
# (
# multijob_child_init
# out=`ls`
# if echo "${out}" | grep foo ; then
# 	echo "YEAH"
# fi
# ) &
# multijob_post_fork
#
# # 2nd form: execute multiple stuff in the background (pre fork):
# multijob_pre_fork
# (
# multijob_child_init
# out=`ls`
# if echo "${out}" | grep foo ; then
# 	echo "YEAH"
# fi
# ) &
# @CODE
multijob_child_init() {
	local mode="pre"
	case $1 in
	--pre)  mode="pre" ; shift ;;
	--post) mode="post"; shift ;;
	esac

	if [[ $# -eq 0 ]] ; then
		trap 'echo ${BASHPID:-$(bashpid)} $? >&'${mj_write_fd} EXIT
		trap 'exit 1' INT TERM
	else
		local ret
		[[ ${mode} == "pre" ]] && { multijob_pre_fork; ret=$?; }
		( multijob_child_init ; "$@" ) &
		[[ ${mode} == "post" ]] && { multijob_post_fork; ret=$?; }
		return ${ret}
	fi
}

# @FUNCTION: _multijob_fork
# @INTERNAL
# @DESCRIPTION:
# Do the actual book keeping.
_multijob_fork() {
	[[ $# -eq 1 ]] || die "incorrect number of arguments"

	local ret=0
	[[ $1 == "post" ]] && : $(( ++mj_num_jobs ))
	if [[ ${mj_num_jobs} -ge ${mj_max_jobs} ]] ; then
		multijob_finish_one
		ret=$?
	fi
	[[ $1 == "pre" ]] && : $(( ++mj_num_jobs ))
	return ${ret}
}

# @FUNCTION: multijob_pre_fork
# @DESCRIPTION:
# You must call this in the parent process before forking a child process.
# If the parallel limit has been hit, it will wait for one child to finish
# and return its exit status.
multijob_pre_fork() { _multijob_fork pre "$@" ; }

# @FUNCTION: multijob_post_fork
# @DESCRIPTION:
# You must call this in the parent process after forking a child process.
# If the parallel limit has been hit, it will wait for one child to finish
# and return its exit status.
multijob_post_fork() { _multijob_fork post "$@" ; }

# @FUNCTION: multijob_finish_one
# @DESCRIPTION:
# Wait for a single process to exit and return its exit code.
multijob_finish_one() {
	[[ $# -eq 0 ]] || die "${FUNCNAME} takes no arguments"

	local pid ret
	read -r -u ${mj_read_fd} pid ret || die
	: $(( --mj_num_jobs ))
	return ${ret}
}

# @FUNCTION: multijob_finish
# @DESCRIPTION:
# Wait for all pending processes to exit and return the bitwise or
# of all their exit codes.
multijob_finish() {
	local ret=0
	while [[ ${mj_num_jobs} -gt 0 ]] ; do
		multijob_finish_one
		: $(( ret |= $? ))
	done
	# Let bash clean up its internal child tracking state.
	wait

	# Do this after reaping all the children.
	[[ $# -eq 0 ]] || die "${FUNCNAME} takes no arguments"

	# No need to hook anymore.
	EBUILD_DEATH_HOOKS=${EBUILD_DEATH_HOOKS/ wait / }

	return ${ret}
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
