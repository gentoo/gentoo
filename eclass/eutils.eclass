# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: eutils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: many extra (but common) functions that are used in ebuilds
# @DESCRIPTION:
# The eutils eclass contains a suite of functions that complement
# the ones that ebuild.sh already contain.  The idea is that the functions
# are not required in all ebuilds but enough utilize them to have a common
# home rather than having multiple ebuilds implementing the same thing.
#
# Due to the nature of this eclass, some functions may have maintainers
# different from the overall eclass!

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

inherit multilib toolchain-funcs

if has "${EAPI:-0}" 0 1 2; then

# @FUNCTION: epause
# @USAGE: [seconds]
# @DESCRIPTION:
# Sleep for the specified number of seconds (default of 5 seconds).  Useful when
# printing a message the user should probably be reading and often used in
# conjunction with the ebeep function.  If the EPAUSE_IGNORE env var is set,
# don't wait at all. Defined in EAPIs 0 1 and 2.
epause() {
	[[ -z ${EPAUSE_IGNORE} ]] && sleep ${1:-5}
}

# @FUNCTION: ebeep
# @USAGE: [number of beeps]
# @DESCRIPTION:
# Issue the specified number of beeps (default of 5 beeps).  Useful when
# printing a message the user should probably be reading and often used in
# conjunction with the epause function.  If the EBEEP_IGNORE env var is set,
# don't beep at all. Defined in EAPIs 0 1 and 2.
ebeep() {
	local n
	if [[ -z ${EBEEP_IGNORE} ]] ; then
		for ((n=1 ; n <= ${1:-5} ; n++)) ; do
			echo -ne "\a"
			sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
			echo -ne "\a"
			sleep 1
		done
	fi
}

else

ebeep() {
	ewarn "QA Notice: ebeep is not defined in EAPI=${EAPI}, please file a bug at https://bugs.gentoo.org"
}

epause() {
	ewarn "QA Notice: epause is not defined in EAPI=${EAPI}, please file a bug at https://bugs.gentoo.org"
}

fi

# @FUNCTION: eqawarn
# @USAGE: [message]
# @DESCRIPTION:
# Proxy to ewarn for package managers that don't provide eqawarn and use the PM
# implementation if available. Reuses PORTAGE_ELOG_CLASSES as set by the dev
# profile.
if ! declare -F eqawarn >/dev/null ; then
	eqawarn() {
		has qa ${PORTAGE_ELOG_CLASSES} && ewarn "$@"
		:
	}
fi

# @FUNCTION: ecvs_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove CVS directories recursiveley.  Useful when a source tarball contains
# internal CVS directories.  Defaults to $PWD.
ecvs_clean() {
	[[ -z $* ]] && set -- .
	find "$@" -type d -name 'CVS' -prune -print0 | xargs -0 rm -rf
	find "$@" -type f -name '.cvs*' -print0 | xargs -0 rm -rf
}

# @FUNCTION: esvn_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .svn directories recursiveley.  Useful when a source tarball contains
# internal Subversion directories.  Defaults to $PWD.
esvn_clean() {
	[[ -z $* ]] && set -- .
	find "$@" -type d -name '.svn' -prune -print0 | xargs -0 rm -rf
}

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
	eval unset ${_estack_name}\[${_estack_i}\]
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

# @VARIABLE: EPATCH_SOURCE
# @DESCRIPTION:
# Default directory to search for patches.
EPATCH_SOURCE="${WORKDIR}/patch"
# @VARIABLE: EPATCH_SUFFIX
# @DESCRIPTION:
# Default extension for patches (do not prefix the period yourself).
EPATCH_SUFFIX="patch.bz2"
# @VARIABLE: EPATCH_OPTS
# @DESCRIPTION:
# Options to pass to patch.  Meant for ebuild/package-specific tweaking
# such as forcing the patch level (-p#) or fuzz (-F#) factor.  Note that
# for single patch tweaking, you can also pass flags directly to epatch.
EPATCH_OPTS=""
# @VARIABLE: EPATCH_COMMON_OPTS
# @DESCRIPTION:
# Common options to pass to `patch`.  You probably should never need to
# change these.  If you do, please discuss it with base-system first to
# be sure.
# @CODE
#	-g0 - keep RCS, ClearCase, Perforce and SCCS happy #24571
#	--no-backup-if-mismatch - do not leave .orig files behind
#	-E - automatically remove empty files
# @CODE
EPATCH_COMMON_OPTS="-g0 -E --no-backup-if-mismatch"
# @VARIABLE: EPATCH_EXCLUDE
# @DESCRIPTION:
# List of patches not to apply.	 Note this is only file names,
# and not the full path.  Globs accepted.
EPATCH_EXCLUDE=""
# @VARIABLE: EPATCH_SINGLE_MSG
# @DESCRIPTION:
# Change the printed message for a single patch.
EPATCH_SINGLE_MSG=""
# @VARIABLE: EPATCH_MULTI_MSG
# @DESCRIPTION:
# Change the printed message for multiple patches.
EPATCH_MULTI_MSG="Applying various patches (bugfixes/updates) ..."
# @VARIABLE: EPATCH_FORCE
# @DESCRIPTION:
# Only require patches to match EPATCH_SUFFIX rather than the extended
# arch naming style.
EPATCH_FORCE="no"
# @VARIABLE: EPATCH_USER_EXCLUDE
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of patches not to apply.	 Note this is only file names,
# and not the full path.  Globs accepted.

# @FUNCTION: epatch
# @USAGE: [options] [patches] [dirs of patches]
# @DESCRIPTION:
# epatch is designed to greatly simplify the application of patches.  It can
# process patch files directly, or directories of patches.  The patches may be
# compressed (bzip/gzip/etc...) or plain text.  You generally need not specify
# the -p option as epatch will automatically attempt -p0 to -p4 until things
# apply successfully.
#
# If you do not specify any patches/dirs, then epatch will default to the
# directory specified by EPATCH_SOURCE.
#
# Any options specified that start with a dash will be passed down to patch
# for this specific invocation.  As soon as an arg w/out a dash is found, then
# arg processing stops.
#
# When processing directories, epatch will apply all patches that match:
# @CODE
#	if ${EPATCH_FORCE} != "yes"
#		??_${ARCH}_foo.${EPATCH_SUFFIX}
#	else
#		*.${EPATCH_SUFFIX}
# @CODE
# The leading ?? are typically numbers used to force consistent patch ordering.
# The arch field is used to apply patches only for the host architecture with
# the special value of "all" means apply for everyone.  Note that using values
# other than "all" is highly discouraged -- you should apply patches all the
# time and let architecture details be detected at configure/compile time.
#
# If EPATCH_SUFFIX is empty, then no period before it is implied when searching
# for patches to apply.
#
# Refer to the other EPATCH_xxx variables for more customization of behavior.
epatch() {
	_epatch_draw_line() {
		# create a line of same length as input string
		[[ -z $1 ]] && set "$(printf "%65s" '')"
		echo "${1//?/=}"
	}

	unset P4CONFIG P4PORT P4USER # keep perforce at bay #56402

	# First process options.  We localize the EPATCH_OPTS setting
	# from above so that we can pass it on in the loop below with
	# any additional values the user has specified.
	local EPATCH_OPTS=( ${EPATCH_OPTS[*]} )
	while [[ $# -gt 0 ]] ; do
		case $1 in
		-*) EPATCH_OPTS+=( "$1" ) ;;
		*) break ;;
		esac
		shift
	done

	# Let the rest of the code process one user arg at a time --
	# each arg may expand into multiple patches, and each arg may
	# need to start off with the default global EPATCH_xxx values
	if [[ $# -gt 1 ]] ; then
		local m
		for m in "$@" ; do
			epatch "${m}"
		done
		return 0
	fi

	local SINGLE_PATCH="no"
	# no args means process ${EPATCH_SOURCE}
	[[ $# -eq 0 ]] && set -- "${EPATCH_SOURCE}"

	if [[ -f $1 ]] ; then
		SINGLE_PATCH="yes"
		set -- "$1"
		# Use the suffix from the single patch (localize it); the code
		# below will find the suffix for us
		local EPATCH_SUFFIX=$1

	elif [[ -d $1 ]] ; then
		# We have to force sorting to C so that the wildcard expansion is consistent #471666.
		evar_push_set LC_COLLATE C
		# Some people like to make dirs of patches w/out suffixes (vim).
		set -- "$1"/*${EPATCH_SUFFIX:+."${EPATCH_SUFFIX}"}
		evar_pop

	elif [[ -f ${EPATCH_SOURCE}/$1 ]] ; then
		# Re-use EPATCH_SOURCE as a search dir
		epatch "${EPATCH_SOURCE}/$1"
		return $?

	else
		# sanity check ... if it isn't a dir or file, wtf man ?
		[[ $# -ne 0 ]] && EPATCH_SOURCE=$1
		echo
		eerror "Cannot find \$EPATCH_SOURCE!  Value for \$EPATCH_SOURCE is:"
		eerror
		eerror "  ${EPATCH_SOURCE}"
		eerror "  ( ${EPATCH_SOURCE##*/} )"
		echo
		die "Cannot find \$EPATCH_SOURCE!"
	fi

	# Now that we know we're actually going to apply something, merge
	# all of the patch options back in to a single variable for below.
	EPATCH_OPTS="${EPATCH_COMMON_OPTS} ${EPATCH_OPTS[*]}"

	local PIPE_CMD
	case ${EPATCH_SUFFIX##*\.} in
		xz)      PIPE_CMD="xz -dc"    ;;
		lzma)    PIPE_CMD="lzma -dc"  ;;
		bz2)     PIPE_CMD="bzip2 -dc" ;;
		gz|Z|z)  PIPE_CMD="gzip -dc"  ;;
		ZIP|zip) PIPE_CMD="unzip -p"  ;;
		*)       ;;
	esac

	[[ ${SINGLE_PATCH} == "no" ]] && einfo "${EPATCH_MULTI_MSG}"

	local x
	for x in "$@" ; do
		# If the patch dir given contains subdirs, or our EPATCH_SUFFIX
		# didn't match anything, ignore continue on
		[[ ! -f ${x} ]] && continue

		local patchname=${x##*/}

		# Apply single patches, or forced sets of patches, or
		# patches with ARCH dependant names.
		#	???_arch_foo.patch
		# Else, skip this input altogether
		local a=${patchname#*_} # strip the ???_
		a=${a%%_*}              # strip the _foo.patch
		if ! [[ ${SINGLE_PATCH} == "yes" || \
				${EPATCH_FORCE} == "yes" || \
				${a} == all     || \
				${a} == ${ARCH} ]]
		then
			continue
		fi

		# Let people filter things dynamically
		if [[ -n ${EPATCH_EXCLUDE}${EPATCH_USER_EXCLUDE} ]] ; then
			# let people use globs in the exclude
			eshopts_push -o noglob

			local ex
			for ex in ${EPATCH_EXCLUDE} ; do
				if [[ ${patchname} == ${ex} ]] ; then
					einfo "  Skipping ${patchname} due to EPATCH_EXCLUDE ..."
					eshopts_pop
					continue 2
				fi
			done

			for ex in ${EPATCH_USER_EXCLUDE} ; do
				if [[ ${patchname} == ${ex} ]] ; then
					einfo "  Skipping ${patchname} due to EPATCH_USER_EXCLUDE ..."
					eshopts_pop
					continue 2
				fi
			done

			eshopts_pop
		fi

		if [[ ${SINGLE_PATCH} == "yes" ]] ; then
			if [[ -n ${EPATCH_SINGLE_MSG} ]] ; then
				einfo "${EPATCH_SINGLE_MSG}"
			else
				einfo "Applying ${patchname} ..."
			fi
		else
			einfo "  ${patchname} ..."
		fi

		# Handle aliased patch command #404447 #461568
		local patch="patch"
		eval $(alias patch 2>/dev/null | sed 's:^alias ::')

		# most of the time, there will only be one run per unique name,
		# but if there are more, make sure we get unique log filenames
		local STDERR_TARGET="${T}/${patchname}.out"
		if [[ -e ${STDERR_TARGET} ]] ; then
			STDERR_TARGET="${T}/${patchname}-$$.out"
		fi

		printf "***** %s *****\nPWD: %s\nPATCH TOOL: %s -> %s\nVERSION INFO:\n%s\n\n" \
			"${patchname}" \
			"${PWD}" \
			"${patch}" \
			"$(type -P "${patch}")" \
			"$(${patch} --version)" \
			> "${STDERR_TARGET}"

		# Decompress the patch if need be
		local count=0
		local PATCH_TARGET
		if [[ -n ${PIPE_CMD} ]] ; then
			PATCH_TARGET="${T}/$$.patch"
			echo "PIPE_COMMAND:  ${PIPE_CMD} ${x} > ${PATCH_TARGET}" >> "${STDERR_TARGET}"

			if ! (${PIPE_CMD} "${x}" > "${PATCH_TARGET}") >> "${STDERR_TARGET}" 2>&1 ; then
				echo
				eerror "Could not extract patch!"
				#die "Could not extract patch!"
				count=5
				break
			fi
		else
			PATCH_TARGET=${x}
		fi

		# Check for absolute paths in patches.  If sandbox is disabled,
		# people could (accidently) patch files in the root filesystem.
		# Or trigger other unpleasantries #237667.  So disallow -p0 on
		# such patches.
		local abs_paths=$(egrep -n '^[-+]{3} /' "${PATCH_TARGET}" | awk '$2 != "/dev/null" { print }')
		if [[ -n ${abs_paths} ]] ; then
			count=1
			printf "NOTE: skipping -p0 due to absolute paths in patch:\n%s\n" "${abs_paths}" >> "${STDERR_TARGET}"
		fi
		# Similar reason, but with relative paths.
		local rel_paths=$(egrep -n '^[-+]{3} [^	]*[.][.]/' "${PATCH_TARGET}")
		if [[ -n ${rel_paths} ]] ; then
			echo
			eerror "Rejected Patch: ${patchname} !"
			eerror " ( ${PATCH_TARGET} )"
			eerror
			eerror "Your patch uses relative paths '../':"
			eerror "${rel_paths}"
			echo
			die "you need to fix the relative paths in patch"
		fi

		# Dynamically detect the correct -p# ... i'm lazy, so shoot me :/
		local patch_cmd
		while [[ ${count} -lt 5 ]] ; do
			patch_cmd="${patch} -p${count} ${EPATCH_OPTS}"

			# Generate some useful debug info ...
			(
			_epatch_draw_line "***** ${patchname} *****"
			echo
			echo "PATCH COMMAND:  ${patch_cmd} < '${PATCH_TARGET}'"
			echo
			_epatch_draw_line "***** ${patchname} *****"
			${patch_cmd} --dry-run -f < "${PATCH_TARGET}" 2>&1
			ret=$?
			echo
			echo "patch program exited with status ${ret}"
			exit ${ret}
			) >> "${STDERR_TARGET}"

			if [ $? -eq 0 ] ; then
				(
				_epatch_draw_line "***** ${patchname} *****"
				echo
				echo "ACTUALLY APPLYING ${patchname} ..."
				echo
				_epatch_draw_line "***** ${patchname} *****"
				${patch_cmd} < "${PATCH_TARGET}" 2>&1
				ret=$?
				echo
				echo "patch program exited with status ${ret}"
				exit ${ret}
				) >> "${STDERR_TARGET}"

				if [ $? -ne 0 ] ; then
					echo
					eerror "A dry-run of patch command succeeded, but actually"
					eerror "applying the patch failed!"
					#die "Real world sux compared to the dreamworld!"
					count=5
				fi
				break
			fi

			: $(( count++ ))
		done

		# if we had to decompress the patch, delete the temp one
		if [[ -n ${PIPE_CMD} ]] ; then
			rm -f "${PATCH_TARGET}"
		fi

		if [[ ${count} -ge 5 ]] ; then
			echo
			eerror "Failed Patch: ${patchname} !"
			eerror " ( ${PATCH_TARGET} )"
			eerror
			eerror "Include in your bugreport the contents of:"
			eerror
			eerror "  ${STDERR_TARGET}"
			echo
			die "Failed Patch: ${patchname}!"
		fi

		# if everything worked, delete the full debug patch log
		rm -f "${STDERR_TARGET}"

		# then log away the exact stuff for people to review later
		cat <<-EOF >> "${T}/epatch.log"
		PATCH: ${x}
		CMD: ${patch_cmd}
		PWD: ${PWD}

		EOF
		eend 0
	done

	[[ ${SINGLE_PATCH} == "no" ]] && einfo "Done with patching"
	: # everything worked
}

# @FUNCTION: epatch_user
# @USAGE:
# @DESCRIPTION:
# Applies user-provided patches to the source tree. The patches are
# taken from /etc/portage/patches/<CATEGORY>/<P-PR|P|PN>[:SLOT]/, where the first
# of these three directories to exist will be the one to use, ignoring
# any more general directories which might exist as well. They must end
# in ".patch" to be applied.
#
# User patches are intended for quick testing of patches without ebuild
# modifications, as well as for permanent customizations a user might
# desire. Obviously, there can be no official support for arbitrarily
# patched ebuilds. So whenever a build log in a bug report mentions that
# user patches were applied, the user should be asked to reproduce the
# problem without these.
#
# Not all ebuilds do call this function, so placing patches in the
# stated directory might or might not work, depending on the package and
# the eclasses it inherits and uses. It is safe to call the function
# repeatedly, so it is always possible to add a call at the ebuild
# level. The first call is the time when the patches will be
# applied.
#
# Ideally, this function should be called after gentoo-specific patches
# have been applied, so that their code can be modified as well, but
# before calls to e.g. eautoreconf, as the user patches might affect
# autotool input files as well.
epatch_user() {
	[[ $# -ne 0 ]] && die "epatch_user takes no options"

	# Allow multiple calls to this function; ignore all but the first
	local applied="${T}/epatch_user.log"
	[[ -e ${applied} ]] && return 2

	# don't clobber any EPATCH vars that the parent might want
	local EPATCH_SOURCE check base=${PORTAGE_CONFIGROOT%/}/etc/portage/patches
	for check in ${CATEGORY}/{${P}-${PR},${P},${PN}}{,:${SLOT}}; do
		EPATCH_SOURCE=${base}/${CTARGET}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${CHOST}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${check}
		if [[ -d ${EPATCH_SOURCE} ]] ; then
			EPATCH_SOURCE=${EPATCH_SOURCE} \
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
			EPATCH_MULTI_MSG="Applying user patches from ${EPATCH_SOURCE} ..." \
			epatch
			echo "${EPATCH_SOURCE}" > "${applied}"
			has epatch_user_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" epatch_user_death_notice"
			return 0
		fi
	done
	echo "none" > "${applied}"
	return 1
}
# @FUNCTION: epatch_user_death_notice
# @INTERNAL
# @DESCRIPTION:
# Include an explicit notice in the die message itself that user patches were
# applied to this build.
epatch_user_death_notice() {
	ewarn "!!! User patches were applied to this build!"
}

# @FUNCTION: emktemp
# @USAGE: [temp dir]
# @DESCRIPTION:
# Cheap replacement for when debianutils (and thus mktemp)
# does not exist on the users system.
emktemp() {
	local exe="touch"
	[[ $1 == -d ]] && exe="mkdir" && shift
	local topdir=$1

	if [[ -z ${topdir} ]] ; then
		[[ -z ${T} ]] \
			&& topdir="/tmp" \
			|| topdir=${T}
	fi

	if ! type -P mktemp > /dev/null ; then
		# system lacks `mktemp` so we have to fake it
		local tmp=/
		while [[ -e ${tmp} ]] ; do
			tmp=${topdir}/tmp.${RANDOM}.${RANDOM}.${RANDOM}
		done
		${exe} "${tmp}" || ${exe} -p "${tmp}"
		echo "${tmp}"
	else
		# the args here will give slightly wierd names on BSD,
		# but should produce a usable file on all userlands
		if [[ ${exe} == "touch" ]] ; then
			TMPDIR="${topdir}" mktemp -t tmp.XXXXXXXXXX
		else
			TMPDIR="${topdir}" mktemp -dt tmp.XXXXXXXXXX
		fi
	fi
}

# @FUNCTION: edos2unix
# @USAGE: <file> [more files ...]
# @DESCRIPTION:
# A handy replacement for dos2unix, recode, fixdos, etc...  This allows you
# to remove all of these text utilities from DEPEND variables because this
# is a script based solution.  Just give it a list of files to convert and
# they will all be changed from the DOS CRLF format to the UNIX LF format.
edos2unix() {
	[[ $# -eq 0 ]] && return 0
	sed -i 's/\r$//' -- "$@" || die
}

# @FUNCTION: make_desktop_entry
# @USAGE: make_desktop_entry(<command>, [name], [icon], [type], [fields])
# @DESCRIPTION:
# Make a .desktop file.
#
# @CODE
# binary:   what command does the app run with ?
# name:     the name that will show up in the menu
# icon:     the icon to use in the menu entry
#           this can be relative (to /usr/share/pixmaps) or
#           a full path to an icon
# type:     what kind of application is this?
#           for categories:
#           http://standards.freedesktop.org/menu-spec/latest/apa.html
#           if unset, function tries to guess from package's category
# fields:	extra fields to append to the desktop file; a printf string
# @CODE
make_desktop_entry() {
	[[ -z $1 ]] && die "make_desktop_entry: You must specify the executable"

	local exec=${1}
	local name=${2:-${PN}}
	local icon=${3:-${PN}}
	local type=${4}
	local fields=${5}

	if [[ -z ${type} ]] ; then
		local catmaj=${CATEGORY%%-*}
		local catmin=${CATEGORY##*-}
		case ${catmaj} in
			app)
				case ${catmin} in
					accessibility) type="Utility;Accessibility";;
					admin)         type=System;;
					antivirus)     type=System;;
					arch)          type="Utility;Archiving";;
					backup)        type="Utility;Archiving";;
					cdr)           type="AudioVideo;DiscBurning";;
					dicts)         type="Office;Dictionary";;
					doc)           type=Documentation;;
					editors)       type="Utility;TextEditor";;
					emacs)         type="Development;TextEditor";;
					emulation)     type="System;Emulator";;
					laptop)        type="Settings;HardwareSettings";;
					office)        type=Office;;
					pda)           type="Office;PDA";;
					vim)           type="Development;TextEditor";;
					xemacs)        type="Development;TextEditor";;
				esac
				;;

			dev)
				type="Development"
				;;

			games)
				case ${catmin} in
					action|fps) type=ActionGame;;
					arcade)     type=ArcadeGame;;
					board)      type=BoardGame;;
					emulation)  type=Emulator;;
					kids)       type=KidsGame;;
					puzzle)     type=LogicGame;;
					roguelike)  type=RolePlaying;;
					rpg)        type=RolePlaying;;
					simulation) type=Simulation;;
					sports)     type=SportsGame;;
					strategy)   type=StrategyGame;;
				esac
				type="Game;${type}"
				;;

			gnome)
				type="Gnome;GTK"
				;;

			kde)
				type="KDE;Qt"
				;;

			mail)
				type="Network;Email"
				;;

			media)
				case ${catmin} in
					gfx)
						type=Graphics
						;;
					*)
						case ${catmin} in
							radio) type=Tuner;;
							sound) type=Audio;;
							tv)    type=TV;;
							video) type=Video;;
						esac
						type="AudioVideo;${type}"
						;;
				esac
				;;

			net)
				case ${catmin} in
					dialup) type=Dialup;;
					ftp)    type=FileTransfer;;
					im)     type=InstantMessaging;;
					irc)    type=IRCClient;;
					mail)   type=Email;;
					news)   type=News;;
					nntp)   type=News;;
					p2p)    type=FileTransfer;;
					voip)   type=Telephony;;
				esac
				type="Network;${type}"
				;;

			sci)
				case ${catmin} in
					astro*)  type=Astronomy;;
					bio*)    type=Biology;;
					calc*)   type=Calculator;;
					chem*)   type=Chemistry;;
					elec*)   type=Electronics;;
					geo*)    type=Geology;;
					math*)   type=Math;;
					physics) type=Physics;;
					visual*) type=DataVisualization;;
				esac
				type="Education;Science;${type}"
				;;

			sys)
				type="System"
				;;

			www)
				case ${catmin} in
					client) type=WebBrowser;;
				esac
				type="Network;${type}"
				;;

			*)
				type=
				;;
		esac
	fi
	local slot=${SLOT%/*}
	if [[ ${slot} == "0" ]] ; then
		local desktop_name="${PN}"
	else
		local desktop_name="${PN}-${slot}"
	fi
	local desktop="${T}/$(echo ${exec} | sed 's:[[:space:]/:]:_:g')-${desktop_name}.desktop"
	#local desktop=${T}/${exec%% *:-${desktop_name}}.desktop

	# Don't append another ";" when a valid category value is provided.
	type=${type%;}${type:+;}

	eshopts_push -s extglob
	if [[ -n ${icon} && ${icon} != /* ]] && [[ ${icon} == *.xpm || ${icon} == *.png || ${icon} == *.svg ]]; then
		ewarn "As described in the Icon Theme Specification, icon file extensions are not"
		ewarn "allowed in .desktop files if the value is not an absolute path."
		icon=${icon%.@(xpm|png|svg)}
	fi
	eshopts_pop

	cat <<-EOF > "${desktop}"
	[Desktop Entry]
	Name=${name}
	Type=Application
	Comment=${DESCRIPTION}
	Exec=${exec}
	TryExec=${exec%% *}
	Icon=${icon}
	Categories=${type}
	EOF

	if [[ ${fields:-=} != *=* ]] ; then
		# 5th arg used to be value to Path=
		ewarn "make_desktop_entry: update your 5th arg to read Path=${fields}"
		fields="Path=${fields}"
	fi
	[[ -n ${fields} ]] && printf '%b\n' "${fields}" >> "${desktop}"

	(
		# wrap the env here so that the 'insinto' call
		# doesn't corrupt the env of the caller
		insinto /usr/share/applications
		doins "${desktop}"
	) || die "installing desktop file failed"
}

# @FUNCTION: _eutils_eprefix_init
# @INTERNAL
# @DESCRIPTION:
# Initialized prefix variables for EAPI<3.
_eutils_eprefix_init() {
	has "${EAPI:-0}" 0 1 2 && : ${ED:=${D}} ${EPREFIX:=} ${EROOT:=${ROOT}}
}

# @FUNCTION: validate_desktop_entries
# @USAGE: [directories]
# @MAINTAINER:
# Carsten Lohrke <carlo@gentoo.org>
# @DESCRIPTION:
# Validate desktop entries using desktop-file-utils
validate_desktop_entries() {
	_eutils_eprefix_init
	if [[ -x "${EPREFIX}"/usr/bin/desktop-file-validate ]] ; then
		einfo "Checking desktop entry validity"
		local directories=""
		for d in /usr/share/applications $@ ; do
			[[ -d ${ED}${d} ]] && directories="${directories} ${ED}${d}"
		done
		if [[ -n ${directories} ]] ; then
			for FILE in $(find ${directories} -name "*\.desktop" \
							-not -path '*.hidden*' | sort -u 2>/dev/null)
			do
				local temp=$(desktop-file-validate ${FILE} | grep -v "warning:" | \
								sed -e "s|error: ||" -e "s|${FILE}:|--|g" )
				[[ -n $temp ]] && elog ${temp/--/${FILE/${ED}/}:}
			done
		fi
		echo ""
	else
		einfo "Passing desktop entry validity check. Install dev-util/desktop-file-utils, if you want to help to improve Gentoo."
	fi
}

# @FUNCTION: make_session_desktop
# @USAGE: <title> <command> [command args...]
# @DESCRIPTION:
# Make a GDM/KDM Session file.  The title is the file to execute to start the
# Window Manager.  The command is the name of the Window Manager.
#
# You can set the name of the file via the ${wm} variable.
make_session_desktop() {
	[[ -z $1 ]] && eerror "$0: You must specify the title" && return 1
	[[ -z $2 ]] && eerror "$0: You must specify the command" && return 1

	local title=$1
	local command=$2
	local desktop=${T}/${wm:-${PN}}.desktop
	shift 2

	cat <<-EOF > "${desktop}"
	[Desktop Entry]
	Name=${title}
	Comment=This session logs you into ${title}
	Exec=${command} $*
	TryExec=${command}
	Type=XSession
	EOF

	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	insinto /usr/share/xsessions
	doins "${desktop}"
	)
}

# @FUNCTION: domenu
# @USAGE: <menus>
# @DESCRIPTION:
# Install the list of .desktop menu files into the appropriate directory
# (/usr/share/applications).
domenu() {
	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	local i j ret=0
	insinto /usr/share/applications
	for i in "$@" ; do
		if [[ -f ${i} ]] ; then
			doins "${i}"
			((ret+=$?))
		elif [[ -d ${i} ]] ; then
			for j in "${i}"/*.desktop ; do
				doins "${j}"
				((ret+=$?))
			done
		else
			((++ret))
		fi
	done
	exit ${ret}
	)
}

# @FUNCTION: newmenu
# @USAGE: <menu> <newname>
# @DESCRIPTION:
# Like all other new* functions, install the specified menu as newname.
newmenu() {
	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	insinto /usr/share/applications
	newins "$@"
	)
}

# @FUNCTION: _iconins
# @INTERNAL
# @DESCRIPTION:
# function for use in doicon and newicon
_iconins() {
	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	local funcname=$1; shift
	local size dir
	local context=apps
	local theme=hicolor

	while [[ $# -gt 0 ]] ; do
		case $1 in
		-s|--size)
			if [[ ${2%%x*}x${2%%x*} == "$2" ]] ; then
				size=${2%%x*}
			else
				size=${2}
			fi
			case ${size} in
			16|22|24|32|36|48|64|72|96|128|192|256|512)
				size=${size}x${size};;
			scalable)
				;;
			*)
				eerror "${size} is an unsupported icon size!"
				exit 1;;
			esac
			shift 2;;
		-t|--theme)
			theme=${2}
			shift 2;;
		-c|--context)
			context=${2}
			shift 2;;
		*)
			if [[ -z ${size} ]] ; then
				insinto /usr/share/pixmaps
			else
				insinto /usr/share/icons/${theme}/${size}/${context}
			fi

			if [[ ${funcname} == doicon ]] ; then
				if [[ -f $1 ]] ; then
					doins "${1}"
				elif [[ -d $1 ]] ; then
					shopt -s nullglob
					doins "${1}"/*.{png,svg}
					shopt -u nullglob
				else
					eerror "${1} is not a valid file/directory!"
					exit 1
				fi
			else
				break
			fi
			shift 1;;
		esac
	done
	if [[ ${funcname} == newicon ]] ; then
		newins "$@"
	fi
	) || die
}

# @FUNCTION: doicon
# @USAGE: [options] <icons>
# @DESCRIPTION:
# Install icon into the icon directory /usr/share/icons or into
# /usr/share/pixmaps if "--size" is not set.
# This is useful in conjunction with creating desktop/menu files.
#
# @CODE
#  options:
#  -s, --size
#    !!! must specify to install into /usr/share/icons/... !!!
#    size of the icon, like 48 or 48x48
#    supported icon sizes are:
#    16 22 24 32 36 48 64 72 96 128 192 256 scalable
#  -c, --context
#    defaults to "apps"
#  -t, --theme
#    defaults to "hicolor"
#
# icons: list of icons
#
# example 1: doicon foobar.png fuqbar.svg suckbar.png
# results in: insinto /usr/share/pixmaps
#             doins foobar.png fuqbar.svg suckbar.png
#
# example 2: doicon -s 48 foobar.png fuqbar.png blobbar.png
# results in: insinto /usr/share/icons/hicolor/48x48/apps
#             doins foobar.png fuqbar.png blobbar.png
# @CODE
doicon() {
	_iconins ${FUNCNAME} "$@"
}

# @FUNCTION: newicon
# @USAGE: [options] <icon> <newname>
# @DESCRIPTION:
# Like doicon, install the specified icon as newname.
#
# @CODE
# example 1: newicon foobar.png NEWNAME.png
# results in: insinto /usr/share/pixmaps
#             newins foobar.png NEWNAME.png
#
# example 2: newicon -s 48 foobar.png NEWNAME.png
# results in: insinto /usr/share/icons/hicolor/48x48/apps
#             newins foobar.png NEWNAME.png
# @CODE
newicon() {
	_iconins ${FUNCNAME} "$@"
}

# @FUNCTION: strip-linguas
# @USAGE: [<allow LINGUAS>|<-i|-u> <directories of .po files>]
# @DESCRIPTION:
# Make sure that LINGUAS only contains languages that
# a package can support.  The first form allows you to
# specify a list of LINGUAS.  The -i builds a list of po
# files found in all the directories and uses the
# intersection of the lists.  The -u builds a list of po
# files found in all the directories and uses the union
# of the lists.
strip-linguas() {
	local ls newls nols
	if [[ $1 == "-i" ]] || [[ $1 == "-u" ]] ; then
		local op=$1; shift
		ls=$(find "$1" -name '*.po' -exec basename {} .po ';'); shift
		local d f
		for d in "$@" ; do
			if [[ ${op} == "-u" ]] ; then
				newls=${ls}
			else
				newls=""
			fi
			for f in $(find "$d" -name '*.po' -exec basename {} .po ';') ; do
				if [[ ${op} == "-i" ]] ; then
					has ${f} ${ls} && newls="${newls} ${f}"
				else
					has ${f} ${ls} || newls="${newls} ${f}"
				fi
			done
			ls=${newls}
		done
	else
		ls="$@"
	fi

	nols=""
	newls=""
	for f in ${LINGUAS} ; do
		if has ${f} ${ls} ; then
			newls="${newls} ${f}"
		else
			nols="${nols} ${f}"
		fi
	done
	[[ -n ${nols} ]] \
		&& einfo "Sorry, but ${PN} does not support the LINGUAS:" ${nols}
	export LINGUAS=${newls:1}
}

# @FUNCTION: preserve_old_lib
# @USAGE: <libs to preserve> [more libs]
# @DESCRIPTION:
# These functions are useful when a lib in your package changes ABI SONAME.
# An example might be from libogg.so.0 to libogg.so.1.  Removing libogg.so.0
# would break packages that link against it.  Most people get around this
# by using the portage SLOT mechanism, but that is not always a relevant
# solution, so instead you can call this from pkg_preinst.  See also the
# preserve_old_lib_notify function.
preserve_old_lib() {
	_eutils_eprefix_init
	if [[ ${EBUILD_PHASE} != "preinst" ]] ; then
		eerror "preserve_old_lib() must be called from pkg_preinst() only"
		die "Invalid preserve_old_lib() usage"
	fi
	[[ -z $1 ]] && die "Usage: preserve_old_lib <library to preserve> [more libraries to preserve]"

	# let portage worry about it
	has preserve-libs ${FEATURES} && return 0

	local lib dir
	for lib in "$@" ; do
		[[ -e ${EROOT}/${lib} ]] || continue
		dir=${lib%/*}
		dodir ${dir} || die "dodir ${dir} failed"
		cp "${EROOT}"/${lib} "${ED}"/${lib} || die "cp ${lib} failed"
		touch "${ED}"/${lib}
	done
}

# @FUNCTION: preserve_old_lib_notify
# @USAGE: <libs to notify> [more libs]
# @DESCRIPTION:
# Spit helpful messages about the libraries preserved by preserve_old_lib.
preserve_old_lib_notify() {
	if [[ ${EBUILD_PHASE} != "postinst" ]] ; then
		eerror "preserve_old_lib_notify() must be called from pkg_postinst() only"
		die "Invalid preserve_old_lib_notify() usage"
	fi

	# let portage worry about it
	has preserve-libs ${FEATURES} && return 0

	_eutils_eprefix_init

	local lib notice=0
	for lib in "$@" ; do
		[[ -e ${EROOT}/${lib} ]] || continue
		if [[ ${notice} -eq 0 ]] ; then
			notice=1
			ewarn "Old versions of installed libraries were detected on your system."
			ewarn "In order to avoid breaking packages that depend on these old libs,"
			ewarn "the libraries are not being removed.  You need to run revdep-rebuild"
			ewarn "in order to remove these old dependencies.  If you do not have this"
			ewarn "helper program, simply emerge the 'gentoolkit' package."
			ewarn
		fi
		ewarn "  # revdep-rebuild --library '${lib}' && rm '${lib}'"
	done
}

# @FUNCTION: built_with_use
# @USAGE: [--hidden] [--missing <action>] [-a|-o] <DEPEND ATOM> <List of USE flags>
# @DESCRIPTION:
#
# Deprecated: Use EAPI 2 use deps in DEPEND|RDEPEND and with has_version calls.
#
# A temporary hack until portage properly supports DEPENDing on USE
# flags being enabled in packages.  This will check to see if the specified
# DEPEND atom was built with the specified list of USE flags.  The
# --missing option controls the behavior if called on a package that does
# not actually support the defined USE flags (aka listed in IUSE).
# The default is to abort (call die).  The -a and -o flags control
# the requirements of the USE flags.  They correspond to "and" and "or"
# logic.  So the -a flag means all listed USE flags must be enabled
# while the -o flag means at least one of the listed IUSE flags must be
# enabled.  The --hidden option is really for internal use only as it
# means the USE flag we're checking is hidden expanded, so it won't be found
# in IUSE like normal USE flags.
#
# Remember that this function isn't terribly intelligent so order of optional
# flags matter.
built_with_use() {
	_eutils_eprefix_init
	local hidden="no"
	if [[ $1 == "--hidden" ]] ; then
		hidden="yes"
		shift
	fi

	local missing_action="die"
	if [[ $1 == "--missing" ]] ; then
		missing_action=$2
		shift ; shift
		case ${missing_action} in
			true|false|die) ;;
			*) die "unknown action '${missing_action}'";;
		esac
	fi

	local opt=$1
	[[ ${opt:0:1} = "-" ]] && shift || opt="-a"

	local PKG=$(best_version $1)
	[[ -z ${PKG} ]] && die "Unable to resolve $1 to an installed package"
	shift

	local USEFILE=${EROOT}/var/db/pkg/${PKG}/USE
	local IUSEFILE=${EROOT}/var/db/pkg/${PKG}/IUSE

	# if the IUSE file doesn't exist, the read will error out, we need to handle
	# this gracefully
	if [[ ! -e ${USEFILE} ]] || [[ ! -e ${IUSEFILE} && ${hidden} == "no" ]] ; then
		case ${missing_action} in
			true)	return 0;;
			false)	return 1;;
			die)	die "Unable to determine what USE flags $PKG was built with";;
		esac
	fi

	if [[ ${hidden} == "no" ]] ; then
		local IUSE_BUILT=( $(<"${IUSEFILE}") )
		# Don't check USE_EXPAND #147237
		local expand
		for expand in $(echo ${USE_EXPAND} | tr '[:upper:]' '[:lower:]') ; do
			if [[ $1 == ${expand}_* ]] ; then
				expand=""
				break
			fi
		done
		if [[ -n ${expand} ]] ; then
			if ! has $1 ${IUSE_BUILT[@]#[-+]} ; then
				case ${missing_action} in
					true)  return 0;;
					false) return 1;;
					die)   die "$PKG does not actually support the $1 USE flag!";;
				esac
			fi
		fi
	fi

	local USE_BUILT=$(<${USEFILE})
	while [[ $# -gt 0 ]] ; do
		if [[ ${opt} = "-o" ]] ; then
			has $1 ${USE_BUILT} && return 0
		else
			has $1 ${USE_BUILT} || return 1
		fi
		shift
	done
	[[ ${opt} = "-a" ]]
}

# @FUNCTION: epunt_cxx
# @USAGE: [dir to scan]
# @DESCRIPTION:
# Many configure scripts wrongly bail when a C++ compiler could not be
# detected.  If dir is not specified, then it defaults to ${S}.
#
# https://bugs.gentoo.org/73450
epunt_cxx() {
	local dir=$1
	[[ -z ${dir} ]] && dir=${S}
	ebegin "Removing useless C++ checks"
	local f p any_found
	while IFS= read -r -d '' f; do
		for p in "${PORTDIR}"/eclass/ELT-patches/nocxx/*.patch ; do
			if patch --no-backup-if-mismatch -p1 "${f}" "${p}" >/dev/null ; then
				any_found=1
				break
			fi
		done
	done < <(find "${dir}" -name configure -print0)

	if [[ -z ${any_found} ]]; then
		eqawarn "epunt_cxx called unnecessarily (no C++ checks to punt)."
	fi
	eend 0
}

# @FUNCTION: make_wrapper
# @USAGE: <wrapper> <target> [chdir] [libpaths] [installpath]
# @DESCRIPTION:
# Create a shell wrapper script named wrapper in installpath
# (defaults to the bindir) to execute target (default of wrapper) by
# first optionally setting LD_LIBRARY_PATH to the colon-delimited
# libpaths followed by optionally changing directory to chdir.
make_wrapper() {
	_eutils_eprefix_init
	local wrapper=$1 bin=$2 chdir=$3 libdir=$4 path=$5
	local tmpwrapper=$(emktemp)

	(
	echo '#!/bin/sh'
	[[ -n ${chdir} ]] && printf 'cd "%s"\n' "${EPREFIX}${chdir}"
	if [[ -n ${libdir} ]] ; then
		local var
		if [[ ${CHOST} == *-darwin* ]] ; then
			var=DYLD_LIBRARY_PATH
		else
			var=LD_LIBRARY_PATH
		fi
		cat <<-EOF
			if [ "\${${var}+set}" = "set" ] ; then
				export ${var}="\${${var}}:${EPREFIX}${libdir}"
			else
				export ${var}="${EPREFIX}${libdir}"
			fi
		EOF
	fi
	# We don't want to quote ${bin} so that people can pass complex
	# things as ${bin} ... "./someprog --args"
	printf 'exec %s "$@"\n' "${bin/#\//${EPREFIX}/}"
	) > "${tmpwrapper}"
	chmod go+rx "${tmpwrapper}"

	if [[ -n ${path} ]] ; then
		(
		exeinto "${path}"
		newexe "${tmpwrapper}" "${wrapper}"
		) || die
	else
		newbin "${tmpwrapper}" "${wrapper}" || die
	fi
}

# @FUNCTION: path_exists
# @USAGE: [-a|-o] <paths>
# @DESCRIPTION:
# Check if the specified paths exist.  Works for all types of paths
# (files/dirs/etc...).  The -a and -o flags control the requirements
# of the paths.  They correspond to "and" and "or" logic.  So the -a
# flag means all the paths must exist while the -o flag means at least
# one of the paths must exist.  The default behavior is "and".  If no
# paths are specified, then the return value is "false".
path_exists() {
	local opt=$1
	[[ ${opt} == -[ao] ]] && shift || opt="-a"

	# no paths -> return false
	# same behavior as: [[ -e "" ]]
	[[ $# -eq 0 ]] && return 1

	local p r=0
	for p in "$@" ; do
		[[ -e ${p} ]]
		: $(( r += $? ))
	done

	case ${opt} in
		-a) return $(( r != 0 )) ;;
		-o) return $(( r == $# )) ;;
	esac
}

# @FUNCTION: in_iuse
# @USAGE: <flag>
# @DESCRIPTION:
# Determines whether the given flag is in IUSE. Strips IUSE default prefixes
# as necessary.
#
# Note that this function should not be used in the global scope.
in_iuse() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -eq 1 ]] || die "Invalid args to ${FUNCNAME}()"

	local flag=${1}
	local liuse=( ${IUSE} )

	has "${flag}" "${liuse[@]#[+-]}"
}

# @FUNCTION: use_if_iuse
# @USAGE: <flag>
# @DESCRIPTION:
# Return true if the given flag is in USE and IUSE.
#
# Note that this function should not be used in the global scope.
use_if_iuse() {
	in_iuse $1 || return 1
	use $1
}

# @FUNCTION: usex
# @USAGE: <USE flag> [true output] [false output] [true suffix] [false suffix]
# @DESCRIPTION:
# Proxy to declare usex for package managers or EAPIs that do not provide it
# and use the package manager implementation when available (i.e. EAPI >= 5).
# If USE flag is set, echo [true output][true suffix] (defaults to "yes"),
# otherwise echo [false output][false suffix] (defaults to "no").
if has "${EAPI:-0}" 0 1 2 3 4; then
	usex() { use "$1" && echo "${2-yes}$4" || echo "${3-no}$5" ; } #382963
fi

# @FUNCTION: prune_libtool_files
# @USAGE: [--all|--modules]
# @DESCRIPTION:
# Locate unnecessary libtool files (.la) and libtool static archives
# (.a) and remove them from installation image.
#
# By default, .la files are removed whenever the static linkage can
# either be performed using pkg-config or doesn't introduce additional
# flags.
#
# If '--modules' argument is passed, .la files for modules (plugins) are
# removed as well. This is usually useful when the package installs
# plugins and the plugin loader does not use .la files.
#
# If '--all' argument is passed, all .la files are removed without
# performing any heuristic on them. You shouldn't ever use that,
# and instead report a bug in the algorithm instead.
#
# The .a files are only removed whenever corresponding .la files state
# that they should not be linked to, i.e. whenever these files
# correspond to plugins.
#
# Note: if your package installs both static libraries and .pc files
# which use variable substitution for -l flags, you need to add
# pkg-config to your DEPEND.
prune_libtool_files() {
	debug-print-function ${FUNCNAME} "$@"

	local removing_all removing_modules opt
	_eutils_eprefix_init
	for opt; do
		case "${opt}" in
			--all)
				removing_all=1
				removing_modules=1
				;;
			--modules)
				removing_modules=1
				;;
			*)
				die "Invalid argument to ${FUNCNAME}(): ${opt}"
		esac
	done

	local f
	local queue=()
	while IFS= read -r -d '' f; do # for all .la files
		local archivefile=${f/%.la/.a}

		# The following check is done by libtool itself.
		# It helps us avoid removing random files which match '*.la',
		# see bug #468380.
		if ! sed -n -e '/^# Generated by .*libtool/q0;4q1' "${f}"; then
			continue
		fi

		[[ ${f} != ${archivefile} ]] || die 'regex sanity check failed'
		local reason= pkgconfig_scanned=
		local snotlink=$(sed -n -e 's:^shouldnotlink=::p' "${f}")

		if [[ ${snotlink} == yes ]]; then

			# Remove static libs we're not supposed to link against.
			if [[ -f ${archivefile} ]]; then
				einfo "Removing unnecessary ${archivefile#${D%/}} (static plugin)"
				queue+=( "${archivefile}" )
			fi

			# The .la file may be used by a module loader, so avoid removing it
			# unless explicitly requested.
			if [[ ${removing_modules} ]]; then
				reason='module'
			fi

		else

			# Remove .la files when:
			# - user explicitly wants us to remove all .la files,
			# - respective static archive doesn't exist,
			# - they are covered by a .pc file already,
			# - they don't provide any new information (no libs & no flags).

			if [[ ${removing_all} ]]; then
				reason='requested'
			elif [[ ! -f ${archivefile} ]]; then
				reason='no static archive'
			elif [[ ! $(sed -nre \
					"s/^(dependency_libs|inherited_linker_flags)='(.*)'$/\2/p" \
					"${f}") ]]; then
				reason='no libs & flags'
			else
				if [[ ! ${pkgconfig_scanned} ]]; then
					# Create a list of all .pc-covered libs.
					local pc_libs=()
					if [[ ! ${removing_all} ]]; then
						local pc
						local tf=${T}/prune-lt-files.pc
						local pkgconf=$(tc-getPKG_CONFIG)

						while IFS= read -r -d '' pc; do # for all .pc files
							local arg libs

							# Use pkg-config if available (and works),
							# fallback to sed.
							if ${pkgconf} --exists "${pc}" &>/dev/null; then
								sed -e '/^Requires:/d' "${pc}" > "${tf}"
								libs=$(${pkgconf} --libs "${tf}")
							else
								libs=$(sed -ne 's/^Libs://p' "${pc}")
							fi

							for arg in ${libs}; do
								if [[ ${arg} == -l* ]]; then
									if [[ ${arg} == '*$*' ]]; then
										eqawarn "${FUNCNAME}: variable substitution likely failed in ${pc}"
										eqawarn "(arg: ${arg})"
										eqawarn "Most likely, you need to add virtual/pkgconfig to DEPEND."
									fi

									pc_libs+=( lib${arg#-l}.la )
								fi
							done
						done < <(find "${D}" -type f -name '*.pc' -print0)

						rm -f "${tf}"
					fi

					pkgconfig_scanned=1
				fi # pkgconfig_scanned

				has "${f##*/}" "${pc_libs[@]}" && reason='covered by .pc'
			fi # removal due to .pc

		fi # shouldnotlink==no

		if [[ ${reason} ]]; then
			einfo "Removing unnecessary ${f#${D%/}} (${reason})"
			queue+=( "${f}" )
		fi
	done < <(find "${ED}" -xtype f -name '*.la' -print0)

	if [[ ${queue[@]} ]]; then
		rm -f "${queue[@]}"
	fi
}

# @FUNCTION: einstalldocs
# @DESCRIPTION:
# Install documentation using DOCS and HTML_DOCS.
#
# If DOCS is declared and non-empty, all files listed in it are
# installed. The files must exist, otherwise the function will fail.
# In EAPI 4 and subsequent EAPIs DOCS may specify directories as well,
# in other EAPIs using directories is unsupported.
#
# If DOCS is not declared, the files matching patterns given
# in the default EAPI implementation of src_install will be installed.
# If this is undesired, DOCS can be set to empty value to prevent any
# documentation from being installed.
#
# If HTML_DOCS is declared and non-empty, all files and/or directories
# listed in it are installed as HTML docs (using dohtml).
#
# Both DOCS and HTML_DOCS can either be an array or a whitespace-
# separated list. Whenever directories are allowed, '<directory>/.' may
# be specified in order to install all files within the directory
# without creating a sub-directory in docdir.
#
# Passing additional options to dodoc and dohtml is not supported.
# If you needed such a thing, you need to call those helpers explicitly.
einstalldocs() {
	debug-print-function ${FUNCNAME} "${@}"

	local dodoc_opts=-r
	has ${EAPI} 0 1 2 3 && dodoc_opts=

	if ! declare -p DOCS &>/dev/null ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES \
				THANKS BUGS FAQ CREDITS CHANGELOG ; do
			if [[ -s ${d} ]] ; then
				dodoc "${d}" || die
			fi
		done
	elif [[ $(declare -p DOCS) == "declare -a"* ]] ; then
		if [[ ${DOCS[@]} ]] ; then
			dodoc ${dodoc_opts} "${DOCS[@]}" || die
		fi
	else
		if [[ ${DOCS} ]] ; then
			dodoc ${dodoc_opts} ${DOCS} || die
		fi
	fi

	if [[ $(declare -p HTML_DOCS 2>/dev/null) == "declare -a"* ]] ; then
		if [[ ${HTML_DOCS[@]} ]] ; then
			dohtml -r "${HTML_DOCS[@]}" || die
		fi
	else
		if [[ ${HTML_DOCS} ]] ; then
			dohtml -r ${HTML_DOCS} || die
		fi
	fi

	return 0
}

check_license() { die "you no longer need this as portage supports ACCEPT_LICENSE itself"; }

# @FUNCTION: optfeature
# @USAGE: <short description> <package atom to match> [other atoms]
# @DESCRIPTION:
# Print out a message suggesting an optional package (or packages) which
# provide the described functionality
#
# The following snippet would suggest app-misc/foo for optional foo support,
# app-misc/bar or app-misc/baz[bar] for optional bar support
# and either both app-misc/a and app-misc/b or app-misc/c for alphabet support.
# @CODE
#	optfeature "foo support" app-misc/foo
#	optfeature "bar support" app-misc/bar app-misc/baz[bar]
#	optfeature "alphabet support" "app-misc/a app-misc/b" app-misc/c
# @CODE
optfeature() {
	debug-print-function ${FUNCNAME} "$@"
	local i j msg
	local desc=$1
	local flag=0
	shift
	for i; do
		for j in ${i}; do
			if has_version "${j}"; then
				flag=1
			else
				flag=0
				break
			fi
		done
		if [[ ${flag} -eq 1 ]]; then
			break
		fi
	done
	if [[ ${flag} -eq 0 ]]; then
		for i; do
			msg=" "
			for j in ${i}; do
				msg+=" ${j} and"
			done
			msg="${msg:0: -4} for ${desc}"
			elog "${msg}"
		done
	fi
}

fi
