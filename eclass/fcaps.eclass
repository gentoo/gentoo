# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fcaps.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: function to set POSIX file-based capabilities
# @DESCRIPTION:
# This eclass provides a function to set file-based capabilities on binaries.
# This is not the same as USE=caps which controls runtime capability changes,
# often via packages like libcap.
#
# Due to probable capability-loss on moving or copying, this happens in
# pkg_postinst phase (at least for now).
#
# @EXAMPLE:
# You can manually set the caps on ping and ping6 by doing:
# @CODE
# pkg_postinst() {
# 	fcaps cap_net_raw bin/ping bin/ping6
# }
# @CODE
#
# Or set it via the global ebuild var FILECAPS:
# @CODE
# FILECAPS=(
# 	cap_net_raw bin/ping bin/ping6
# )
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FCAPS_ECLASS} ]]; then
_FCAPS_ECLASS=1

IUSE="+filecaps"

# Since it is needed in pkg_postinst() it must be in IDEPEND
case ${EAPI} in
	7) BDEPEND="filecaps? ( sys-libs/libcap )"
	   RDEPEND="filecaps? ( sys-libs/libcap )" ;;
	*) IDEPEND="filecaps? ( sys-libs/libcap )" ;;
esac

# @ECLASS_VARIABLE: FILECAPS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of fcap arguments to use to automatically execute fcaps.  See that
# function for more details.
#
# All args are consumed until the '--' marker is found.  So if you have:
# @CODE
# 	FILECAPS=( moo cow -- fat cat -- chubby penguin )
# @CODE
#
# This will end up executing:
# @CODE
# 	fcaps moo cow
# 	fcaps fat cat
# 	fcaps chubby penguin
# @CODE
#
# Note: If you override pkg_postinst, you must call fcaps_pkg_postinst yourself.

# @ECLASS_VARIABLE: FCAPS_DENY_WORLD_READ
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# When set, deny read access on files updated by the fcaps function.

# @FUNCTION: fcaps
# @USAGE: [-o <owner>] [-g <group>] [-m <mode>] [-M <caps mode>] <capabilities> <file[s]>
# @DESCRIPTION:
# Sets the specified capabilities on the specified files.
#
# The caps option takes the form as expected by the cap_from_text(3) man page.
# If no action is specified, then "=ep" will be used as a default.
#
# If the file is a relative path (e.g. bin/foo rather than /bin/foo), then the
# appropriate path var ($D/$ROOT/etc...) will be prefixed based on the current
# ebuild phase.
#
# The caps mode is used to set the permission on the file if capabilities
# were properly set on the file.  No change is applied by default.
#
# If the system is unable to set capabilities, it will use the specified user,
# group, and mode.  The user and group default to 0.  If mode is unspecified, no
# change is applied.
#
# For example, "-m u+s" may be used to enable suid as a fallback when file caps
# are unavailable.  This should be used with care, typically when the
# application is written to handle dropping privileges itself.
fcaps() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${EUID} -ne 0 ]] ; then
		einfo "Insufficient privileges to execute ${FUNCNAME}, skipping."
		return 0
	fi

	# Process the user options first.
	local owner='0'
	local group='0'
	local mode=
	local caps_mode=

	while [[ $# -gt 0 ]] ; do
		case $1 in
		-o) owner=$2; shift;;
		-g) group=$2; shift;;
		-m) mode=$2; shift;;
		-M) caps_mode=$2; shift;;
		*) break;;
		esac
		shift
	done

	[[ $# -lt 2 ]] && die "${FUNCNAME}: wrong arg count"

	local caps=$1
	[[ ${caps} == *[-=+]* ]] || caps+="=ep"
	shift

	local root
	case ${EBUILD_PHASE} in
	compile|install|preinst)
		root=${ED:-${D}}
		;;
	postinst)
		root=${EROOT:-${ROOT}}
		;;
	esac
	root=${root%/}

	# Process every file!
	local file
	for file ; do
		[[ ${file} != /* ]] && file="${root}/${file}"

		# Remove the read bits if requested.
		if [[ -n ${FCAPS_DENY_WORLD_READ} ]]; then
			chmod go-r "${file}" || die
		fi

		if use filecaps ; then
			# Try to set capabilities.  Ignore errors when the
			# fs doesn't support it, but abort on all others.
			debug-print "${FUNCNAME}: setting caps '${caps}' on '${file}'"

			if [[ -n ${caps_mode} ]]; then
				chmod ${caps_mode} "${file}" || die
			fi

			if ! out=$(LC_ALL=C setcap "${caps}" "${file}" 2>&1) ; then
				case ${out} in
				# ENOTSUP and EOPNOTSUPP might be the same value which means
				# strerror() on them is unstable -- we can get both. #559608
				*"Not supported"*|\
				*"Operation not supported"*)
					local fstype=$(stat -f -c %T "${file}")
					ewarn "Could not set caps on '${file}' due to missing filesystem support:"
					ewarn "* enable XATTR support for '${fstype}' in your kernel (if configurable)"
					ewarn "* mount the fs with the user_xattr option (if not the default)"
					ewarn "* enable the relevant FS_SECURITY option (if configurable)"
					;;
				*)
					eerror "Setting caps '${caps}' on file '${file}' failed:"
					eerror "${out}"
					die "could not set caps"
					;;
				esac
			else
				# Sanity check that everything took.
				setcap -v "${caps}" "${file}" >/dev/null \
					|| die "Checking caps '${caps}' on '${file}' failed"

				# Everything worked.  Move on to the next file.
				continue
			fi
		fi

		# If we're still here, setcaps failed.
		if [[ -n ${mode} ]]; then
			if [[ -n ${owner} || -n ${group} ]]; then
				debug-print "${FUNCNAME}: setting owner on '${file}'"
				chown "${owner}:${group}" "${file}" || die
			fi
			debug-print "${FUNCNAME}: setting mode on '${file}'"
			chmod ${mode} "${file}" || die
		fi
	done
}

# @FUNCTION: fcaps_pkg_postinst
# @DESCRIPTION:
# Process the FILECAPS array.
fcaps_pkg_postinst() {
	local arg args=()
	for arg in "${FILECAPS[@]}" "--" ; do
		if [[ ${arg} == "--" ]] ; then
			fcaps "${args[@]}"
			args=()
		else
			args+=( "${arg}" )
		fi
	done
}

fi

EXPORT_FUNCTIONS pkg_postinst
