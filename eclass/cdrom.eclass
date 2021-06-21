# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cdrom.eclass
# @MAINTAINER:
# games@gentoo.org
# @BLURB: Functions for CD-ROM handling
# @DESCRIPTION:
# Acquire CD(s) for those lovely CD-based emerges.  Yes, this violates
# the whole "non-interactive" policy, but damnit I want CD support!
#
# Do not call these functions in pkg_* phases like pkg_setup as they
# should not be used for binary packages.  Most packages using this
# eclass will require RESTRICT="bindist" but the point still stands.
# The functions are generally called in src_unpack.

if [[ -z ${_CDROM_ECLASS} ]]; then
_CDROM_ECLASS=1

inherit portability

# @ECLASS-VARIABLE: CDROM_OPTIONAL
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# By default, the eclass sets PROPERTIES="interactive" on the assumption
# that people will be using these.  If your package optionally supports
# disc-based installs then set this to "yes" and we'll set things
# conditionally based on USE="cdinstall".
if [[ ${CDROM_OPTIONAL} == "yes" ]] ; then
	IUSE="cdinstall"
	PROPERTIES+=" cdinstall? ( interactive )"
else
	PROPERTIES+=" interactive"
fi

# @FUNCTION: cdrom_get_cds
# @USAGE: <cd1 file>[:alt cd1 file] [cd2 file[:alt cd2 file]] [...]
# @DESCRIPTION:
# Attempt to locate a CD based upon a file that is on the CD.
#
# If the data spans multiple discs then additional arguments can be
# given to check for more files.  Call cdrom_load_next_cd() to scan for
# the next disc in the set.
#
# Sometimes it is necessary to support alternative CD "sets" where the
# contents differ.  Alternative files for each disc can be appended to
# each argument, separated by the : character.  This feature is
# frequently used to support installing from an existing installation.
# Note that after the first disc is detected, the set is locked so
# cdrom_load_next_cd() will only scan for files in that specific set on
# subsequent discs.
#
# The given files can be within named subdirectories.  It is not
# necessary to specify different casings of the same filename as
# matching is done case-insensitively.  Filenames can include special
# characters such as spaces.  Only : is not allowed.
#
# If you don't want each disc to be referred to as "CD #1", "CD #2",
# etc. then you can optionally provide your own names.  Set CDROM_NAME
# for a single disc, CDROM_NAMES as an array for multiple discs, or
# individual CDROM_NAME_# variables for each disc starting from 1.
#
# Despite what you may have seen in older ebuilds, it has never been
# possible to provide per-set disc names.  This would not make sense as
# all the names are initially displayed before the first disc has been
# detected.  As a workaround, you can redefine the name variable(s)
# after the first disc has been detected.
#
# This function ends with a cdrom_load_next_cd() call to scan for the
# first disc.  For more details about variables read and written by this
# eclass, see that function's description.
cdrom_get_cds() {
	unset CDROM_SET
	export CDROM_CURRENT_CD=0
    export CDROM_NUM_CDS="${#}"
    local i
    for i in $(seq ${#}); do
        export CDROM_CHECK_${i}="${!i}"
    done

	# If the user has set CD_ROOT or CD_ROOT_1, don't bother informing
	# them about which discs are needed as they presumably already know.
	if [[ -n ${CD_ROOT}${CD_ROOT_1} ]] ; then
		:

	# Single disc info.
	elif [[ ${#} -eq 1 ]] ; then
		einfo "This ebuild will need the ${CDROM_NAME:-CD for ${PN}}"
		echo
		einfo "If you do not have the CD, but have the data files"
		einfo "mounted somewhere on your filesystem, just export"
		einfo "the variable CD_ROOT so that it points to the"
		einfo "directory containing the files."
		echo
		einfo "For example:"
		einfo "export CD_ROOT=/mnt/cdrom"
		echo

	# Multi disc info.
	else
		_cdrom_set_names
		einfo "This package may need access to ${#} CDs."
		local cdcnt
		for cdcnt in $(seq ${#}); do
			local var=CDROM_NAME_${cdcnt}
			[[ ! -z ${!var} ]] && einfo " CD ${cdcnt}: ${!var}"
		done
		echo
		einfo "If you do not have the CDs, but have the data files"
		einfo "mounted somewhere on your filesystem, just export"
		einfo "the following variables so they point to the right place:"
		einfo $(printf "CD_ROOT_%d " $(seq ${#}))
		echo
		einfo "Or, if you have all the files in the same place, or"
		einfo "you only have one CD, you can export CD_ROOT"
		einfo "and that place will be used as the same data source"
		einfo "for all the CDs."
		echo
		einfo "For example:"
		einfo "export CD_ROOT=/mnt/cdrom"
		echo
	fi

	# Scan for the first disc.
	cdrom_load_next_cd
}

# @FUNCTION: cdrom_load_next_cd
# @DESCRIPTION:
# If multiple arguments were given to cdrom_get_cds() then you can call
# this function to scan for the next disc.  This function is also called
# implicitly to scan for the first disc.
#
# The file(s) given to cdrom_get_cds() are scanned for on any mounted
# filesystem that resembles optical media.  If no match is found then
# the user is prompted to insert and mount the disc and press enter to
# rescan.  This will loop continuously until a match is found or the
# user aborts with Ctrl+C.
#
# The user can override the scan location by setting CD_ROOT for a
# single disc, CD_ROOT if multiple discs are merged into the same
# directory tree (useful for existing installations), or individual
# CD_ROOT_# variables for each disc starting from 1.  If no match is
# found then the function dies with an error as a rescan will not help
# in this instance.
#
# Users wanting to set CD_ROOT or CD_ROOT_# for specific packages
# persistently can do so using Portage's /etc/portage/env feature.
#
# Regardless of which scanning method is used, several variables are set
# by this function for you to use:
#
#  CDROM_ROOT: Root path of the detected disc.
#  CDROM_MATCH: Path of the matched file, relative to CDROM_ROOT.
#  CDROM_ABSMATCH: Absolute path of the matched file.
#  CDROM_SET: The matching set number, starting from 0.
#
# The casing of CDROM_MATCH may not be the same as the argument given to
# cdrom_get_cds() as matching is done case-insensitively.  You should
# therefore use this variable (or CDROM_ABSMATCH) when performing file
# operations to ensure the file is found.  Use newins rather than doins
# to keep the final result consistent and take advantage of Bash
# case-conversion features like ${FOO,,}.
#
# Chances are that you'll need more than just the matched file from each
# disc though.  You should not assume the casing of these files either
# but dealing with this goes beyond the scope of this ebuild.  For a
# good example, see games-action/descent2-data, which combines advanced
# globbing with advanced tar features to concisely deal with
# case-insensitive matching, case conversion, file moves, and
# conditional exclusion.
#
# Copying directly from a mounted disc using doins/newins will remove
# any read-only permissions but be aware of these when copying to an
# intermediate directory first.  Attempting to clean a build directory
# containing read-only files as a non-root user will result in an error.
# If you're using tar as suggested above then you can easily work around
# this with --mode=u+w.
#
# Note that you can only go forwards in the disc list, so make sure you
# only call this function when you're done using the current disc.
#
# If you cd to any location within CDROM_ROOT then remember to leave the
# directory before calling this function again, otherwise the user won't
# be able to unmount the current disc.
cdrom_load_next_cd() {
	local showedmsg=0 showjolietmsg=0

	unset CDROM_ROOT
	((++CDROM_CURRENT_CD))

	_cdrom_set_names

	while true ; do
		local i cdset
		: CD_ROOT_${CDROM_CURRENT_CD}
		export CDROM_ROOT=${CD_ROOT:-${!_}}
		local var="CDROM_CHECK_${CDROM_CURRENT_CD}"
		IFS=: read -r -a cdset -d "" <<< "${!var}"

		for i in $(seq ${CDROM_SET:-0} ${CDROM_SET:-$((${#cdset[@]} - 1))}); do
			local f=${cdset[${i}]} point= node= fs= opts=

			if [[ -z ${CDROM_ROOT} ]] ; then
				while read point node fs opts ; do
					has "${fs}" cd9660 iso9660 udf || continue
					point=${point//\040/ }
					export CDROM_MATCH=$(_cdrom_glob_match "${point}" "${f}")
					[[ -z ${CDROM_MATCH} ]] && continue
					export CDROM_ROOT=${point}
				done <<< "$(get_mounts)"
			else
				export CDROM_MATCH=$(_cdrom_glob_match "${CDROM_ROOT}" "${f}")
			fi

			if [[ -n ${CDROM_MATCH} ]] ; then
				export CDROM_ABSMATCH=${CDROM_ROOT}/${CDROM_MATCH}
				export CDROM_SET=${i}
				break 2
			fi
		done

		# If we get here then we were unable to locate a match. If
		# CDROM_ROOT is non-empty then this implies that a CD_ROOT
		# variable was given and we should therefore abort immediately.
		if [[ -n ${CDROM_ROOT} ]] ; then
			die "unable to locate CD #${CDROM_CURRENT_CD} root at ${CDROM_ROOT}"
		fi

		if [[ ${showedmsg} -eq 0 ]] ; then
			if [[ ${CDROM_NUM_CDS} -eq 1 ]] ; then
				einfo "Please insert+mount the ${CDROM_NAME:-CD for ${PN}} now!"
			else
				local var="CDROM_NAME_${CDROM_CURRENT_CD}"
				if [[ -z ${!var} ]] ; then
					einfo "Please insert+mount CD #${CDROM_CURRENT_CD} for ${PN} now!"
				else
					einfo "Please insert+mount the ${!var} now!"
				fi
			fi
			showedmsg=1
		fi

		einfo "Press return to scan for the CD again"
		einfo "or hit CTRL+C to abort the emerge."

		if [[ ${showjolietmsg} -eq 0 ]] ; then
			showjolietmsg=1
		else
			echo
			ewarn "If you are having trouble with the detection"
			ewarn "of your CD, it is possible that you do not have"
			ewarn "Joliet support enabled in your kernel.  Please"
			ewarn "check that CONFIG_JOLIET is enabled in your kernel."
		fi
		read || die "something is screwed with your system"
	done

	einfo "Found CD #${CDROM_CURRENT_CD} root at ${CDROM_ROOT}"
}

# @FUNCTION: _cdrom_glob_match
# @USAGE: <root directory> <path>
# @INTERNAL
# @DESCRIPTION:
# Locates the given path ($2) within the given root directory ($1)
# case-insensitively and returns the first actual matching path. This
# eclass previously used "find -iname" but it only checked the file
# case-insensitively and not the directories.  There is "find -ipath"
# but this does not intelligently skip non-matching paths, making it
# slow.  Case-insensitive matching can only be applied to patterns so
# extended globbing is used to turn regular strings into patterns.  All
# special characters are escaped so don't worry about breaking this.
_cdrom_glob_match() {
	# The following line turns this:
	#  foo*foo/bar bar/baz/file.zip
	#
	# Into this:
	#  ?(foo\*foo)/?(bar\ bar)/?(baz)/?(file\.zip)
	#
	# This turns every path component into an escaped extended glob
	# pattern to allow case-insensitive matching. Globs cannot span
	# directories so each component becomes an individual pattern.
	local p=\?\($(sed -e 's:[^A-Za-z0-9/]:\\\0:g' -e 's:/:)/?(:g' <<< "$2" || die)\)
	(
		cd "$1" 2>/dev/null || return
		shopt -s extglob nocaseglob nullglob || die
		# The first person to make this work without an eval wins a
		# cookie. It breaks without it when spaces are present.
		eval "ARRAY=( ${p%\?()} )"
		echo ${ARRAY[0]}
	)
}

# @FUNCTION: _cdrom_set_names
# @INTERNAL
# @DESCRIPTION:
# Populate CDROM_NAME_# variables with the CDROM_NAMES array.
_cdrom_set_names() {
	if [[ -n ${CDROM_NAMES} ]] ; then
		local i
		for i in $(seq ${#CDROM_NAMES[@]}); do
			export CDROM_NAME_${i}="${CDROM_NAMES[$((${i} - 1))]}"
		done
	fi
}

fi
