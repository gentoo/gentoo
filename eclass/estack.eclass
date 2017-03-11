# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: estack.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: stack-like value storage support
# @DESCRIPTION:
# Support for storing values on stack-like variables.

if [[ -z ${_ESTACK_ECLASS} ]]; then

# @FUNCTION: estack_push
# @USAGE: <stack> [items to push]
# @DESCRIPTION:
# Push any number of items onto the specified stack.  Pick a name that
# is a valid variable (i.e. stick to alphanumerics), and push as many
# items as you like onto the stack at once.
#
# The following code snippet will echo 5, then 4, then 3, then ...
# @CODE
#		estack_push mystack 1 2 3 4 5
#		while estack_pop mystack i ; do
#			echo "${i}"
#		done
# @CODE
estack_push() {
	[[ $# -eq 0 ]] && die "estack_push: incorrect # of arguments"
	local stack_name="_ESTACK_$1_" ; shift
	eval ${stack_name}+=\( \"\$@\" \)
}

# @FUNCTION: estack_pop
# @USAGE: <stack> [variable]
# @DESCRIPTION:
# Pop a single item off the specified stack.  If a variable is specified,
# the popped item is stored there.  If no more items are available, return
# 1, else return 0.  See estack_push for more info.
estack_pop() {
	[[ $# -eq 0 || $# -gt 2 ]] && die "estack_pop: incorrect # of arguments"

	# We use the fugly _estack_xxx var names to avoid collision with
	# passing back the return value.  If we used "local i" and the
	# caller ran `estack_pop ... i`, we'd end up setting the local
	# copy of "i" rather than the caller's copy.  The _estack_xxx
	# garbage is preferable to using $1/$2 everywhere as that is a
	# bit harder to read.
	local _estack_name="_ESTACK_$1_" ; shift
	local _estack_retvar=$1 ; shift
	eval local _estack_i=\${#${_estack_name}\[@\]}
	# Don't warn -- let the caller interpret this as a failure
	# or as normal behavior (akin to `shift`)
	[[ $(( --_estack_i )) -eq -1 ]] && return 1

	if [[ -n ${_estack_retvar} ]] ; then
		eval ${_estack_retvar}=\"\${${_estack_name}\[${_estack_i}\]}\"
	fi
	eval unset \"${_estack_name}\[${_estack_i}\]\"
}

# @FUNCTION: evar_push
# @USAGE: <variable to save> [more vars to save]
# @DESCRIPTION:
# This let's you temporarily modify a variable and then restore it (including
# set vs unset semantics).  Arrays are not supported at this time.
#
# This is meant for variables where using `local` does not work (such as
# exported variables, or only temporarily changing things in a func).
#
# For example:
# @CODE
#		evar_push LC_ALL
#		export LC_ALL=C
#		... do some stuff that needs LC_ALL=C set ...
#		evar_pop
#
#		# You can also save/restore more than one var at a time
#		evar_push BUTTERFLY IN THE SKY
#		... do stuff with the vars ...
#		evar_pop     # This restores just one var, SKY
#		... do more stuff ...
#		evar_pop 3   # This pops the remaining 3 vars
# @CODE
evar_push() {
	local var val
	for var ; do
		[[ ${!var+set} == "set" ]] \
			&& val=${!var} \
			|| val="unset_76fc3c462065bb4ca959f939e6793f94"
		estack_push evar "${var}" "${val}"
	done
}

# @FUNCTION: evar_push_set
# @USAGE: <variable to save> [new value to store]
# @DESCRIPTION:
# This is a handy shortcut to save and temporarily set a variable.  If a value
# is not specified, the var will be unset.
evar_push_set() {
	local var=$1
	evar_push ${var}
	case $# in
	1) unset ${var} ;;
	2) printf -v "${var}" '%s' "$2" ;;
	*) die "${FUNCNAME}: incorrect # of args: $*" ;;
	esac
}

# @FUNCTION: evar_pop
# @USAGE: [number of vars to restore]
# @DESCRIPTION:
# Restore the variables to the state saved with the corresponding
# evar_push call.  See that function for more details.
evar_pop() {
	local cnt=${1:-bad}
	case $# in
	0) cnt=1 ;;
	1) isdigit "${cnt}" || die "${FUNCNAME}: first arg must be a number: $*" ;;
	*) die "${FUNCNAME}: only accepts one arg: $*" ;;
	esac

	local var val
	while (( cnt-- )) ; do
		estack_pop evar val || die "${FUNCNAME}: unbalanced push"
		estack_pop evar var || die "${FUNCNAME}: unbalanced push"
		[[ ${val} == "unset_76fc3c462065bb4ca959f939e6793f94" ]] \
			&& unset ${var} \
			|| printf -v "${var}" '%s' "${val}"
	done
}

# @FUNCTION: eshopts_push
# @USAGE: [options to `set` or `shopt`]
# @DESCRIPTION:
# Often times code will want to enable a shell option to change code behavior.
# Since changing shell options can easily break other pieces of code (which
# assume the default state), eshopts_push is used to (1) push the current shell
# options onto a stack and (2) pass the specified arguments to set.
#
# If the first argument is '-s' or '-u', we assume you want to call `shopt`
# rather than `set` as there are some options only available via that.
#
# A common example is to disable shell globbing so that special meaning/care
# may be used with variables/arguments to custom functions.  That would be:
# @CODE
#		eshopts_push -o noglob
#		for x in ${foo} ; do
#			if ...some check... ; then
#				eshopts_pop
#				return 0
#			fi
#		done
#		eshopts_pop
# @CODE
eshopts_push() {
	if [[ $1 == -[su] ]] ; then
		estack_push eshopts "$(shopt -p)"
		[[ $# -eq 0 ]] && return 0
		shopt "$@" || die "${FUNCNAME}: bad options to shopt: $*"
	else
		estack_push eshopts $-
		[[ $# -eq 0 ]] && return 0
		set "$@" || die "${FUNCNAME}: bad options to set: $*"
	fi
}

# @FUNCTION: eshopts_pop
# @USAGE:
# @DESCRIPTION:
# Restore the shell options to the state saved with the corresponding
# eshopts_push call.  See that function for more details.
eshopts_pop() {
	local s
	estack_pop eshopts s || die "${FUNCNAME}: unbalanced push"
	if [[ ${s} == "shopt -"* ]] ; then
		eval "${s}" || die "${FUNCNAME}: sanity: invalid shopt options: ${s}"
	else
		set +$-     || die "${FUNCNAME}: sanity: invalid shell settings: $-"
		set -${s}   || die "${FUNCNAME}: sanity: unable to restore saved shell settings: ${s}"
	fi
}

# @FUNCTION: eumask_push
# @USAGE: <new umask>
# @DESCRIPTION:
# Set the umask to the new value specified while saving the previous
# value onto a stack.  Useful for temporarily changing the umask.
eumask_push() {
	estack_push eumask "$(umask)"
	umask "$@" || die "${FUNCNAME}: bad options to umask: $*"
}

# @FUNCTION: eumask_pop
# @USAGE:
# @DESCRIPTION:
# Restore the previous umask state.
eumask_pop() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: we take no options"
	local s
	estack_pop eumask s || die "${FUNCNAME}: unbalanced push"
	umask ${s} || die "${FUNCNAME}: sanity: could not restore umask: ${s}"
}

# @FUNCTION: isdigit
# @USAGE: <number> [more numbers]
# @DESCRIPTION:
# Return true if all arguments are numbers.
isdigit() {
	local d
	for d ; do
		[[ ${d:-bad} == *[!0-9]* ]] && return 1
	done
	return 0
}

_ESTACK_ECLASS=1
fi #_ESTACK_ECLASS
