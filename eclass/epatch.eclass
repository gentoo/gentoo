# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: epatch.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 0 1 2 3 4 5 6
# @BLURB: easy patch application functions
# @DEPRECATED: eapply from EAPI 7
# @DESCRIPTION:
# An eclass providing epatch and epatch_user functions to easily apply
# patches to ebuilds. Mostly superseded by eapply* in EAPI 6.

if [[ -z ${_EPATCH_ECLASS} ]]; then

case ${EAPI:-0} in
	0|1|2|3|4|5|6)
		;;
	*)
		die "${ECLASS}: banned in EAPI=${EAPI}; use eapply* instead";;
esac

inherit estack

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
			eerror "Rejected Patch: ${patchname}!"
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
			echo "PATCH COMMAND:  ${patch_cmd} --dry-run -f < '${PATCH_TARGET}'"
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
				echo "PATCH COMMAND:  ${patch_cmd} < '${PATCH_TARGET}'"
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

		(( EPATCH_N_APPLIED_PATCHES++ ))

		# if we had to decompress the patch, delete the temp one
		if [[ -n ${PIPE_CMD} ]] ; then
			rm -f "${PATCH_TARGET}"
		fi

		if [[ ${count} -ge 5 ]] ; then
			echo
			eerror "Failed patch: ${patchname}!"
			eerror " ( ${PATCH_TARGET} )"
			eerror
			eerror "Include in your bug report the contents of:"
			eerror
			eerror "  ${STDERR_TARGET}"
			echo
			die "Failed patch: ${patchname}!"
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

case ${EAPI:-0} in
0|1|2|3|4|5)

# @VARIABLE: EPATCH_USER_SOURCE
# @DESCRIPTION:
# Location for user patches, see the epatch_user function.
# Should be set by the user. Don't set this in ebuilds.
: ${EPATCH_USER_SOURCE:=${PORTAGE_CONFIGROOT%/}/etc/portage/patches}

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
	local EPATCH_SOURCE check
	for check in ${CATEGORY}/{${P}-${PR},${P},${PN}}{,:${SLOT%/*}}; do
		EPATCH_SOURCE=${EPATCH_USER_SOURCE}/${CTARGET}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${EPATCH_USER_SOURCE}/${CHOST}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${EPATCH_USER_SOURCE}/${check}
		if [[ -d ${EPATCH_SOURCE} ]] ; then
			local old_n_applied_patches=${EPATCH_N_APPLIED_PATCHES:-0}
			EPATCH_SOURCE=${EPATCH_SOURCE} \
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
			EPATCH_MULTI_MSG="Applying user patches from ${EPATCH_SOURCE} ..." \
			epatch
			echo "${EPATCH_SOURCE}" > "${applied}"
			if [[ ${old_n_applied_patches} -lt ${EPATCH_N_APPLIED_PATCHES} ]]; then
				has epatch_user_death_notice ${EBUILD_DEATH_HOOKS} || \
					EBUILD_DEATH_HOOKS+=" epatch_user_death_notice"
			fi
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

esac

_EPATCH_ECLASS=1
fi #_EPATCH_ECLASS
