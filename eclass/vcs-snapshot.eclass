# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vcs-snapshot.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: support eclass for unpacking VCS snapshot tarballs
# @DESCRIPTION:
# THIS ECLASS IS NOT NECESSARY FOR MODERN GITHUB AND GITLAB SNAPSHOTS.
# THEIR DIRECTORY STRUCTURE IS ENTIRELY PREDICTABLE, SO UPDATE YOUR
# EBUILD TO USE /ARCHIVE/ URI AND SET S IF NECESSARY.
#
# This eclass provides a convenience src_unpack() which does unpack all
# the tarballs in SRC_URI to locations matching their (local) names,
# discarding the original parent directory.
#
# The typical use case are VCS tag snapshots coming from BitBucket
# (but not GitHub or GitLab).  They have hash appended to the directory
# name which makes extracting them a painful experience.  But if you are
# using a SRC_URI arrow to rename them (which quite likely you have to
# do anyway), vcs-snapshot will just extract them into matching
# directories.
#
# Please note that this eclass handles only tarballs (.tar, .tar.gz,
# .tar.bz2 & .tar.xz).  For any other file format (or suffix) it will
# fall back to regular unpack.  Support for additional formats may be
# added in the future if necessary.
#
# @EXAMPLE:
#
# @CODE
# EAPI=7
# inherit vcs-snapshot
#
# SRC_URI="
#    https://bitbucket.org/foo/bar/get/${PV}.tar.bz2 -> ${P}.tar.bz2
#    https://bitbucket.org/foo/bar-otherstuff/get/${PV}.tar.bz2
#        -> ${P}-otherstuff.tar.bz2"
# @CODE
#
# and however the tarballs were originally packed, all files will appear
# in ${WORKDIR}/${P} and ${WORKDIR}/${P}-otherstuff respectively.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_VCS_SNAPSHOT_ECLASS} ]]; then
_VCS_SNAPSHOT_ECLASS=1

# @FUNCTION: vcs-snapshot_src_unpack
# @DESCRIPTION:
# Extract all the archives from ${A}. The .tar, .tar.gz, .tar.bz2
# and .tar.xz archives will be unpacked to directories matching their
# local names. Other archive types will be passed down to regular
# unpack.
vcs-snapshot_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	local renamed_any=
	local f

	for f in ${A}
	do
		case "${f}" in
			*.tar|*.tar.gz|*.tar.bz2|*.tar.xz)
				local destdir=${WORKDIR}/${f%.tar*}

				debug-print "${FUNCNAME}: unpacking ${f} to ${destdir}"

				local l topdirs=()
				while read -r l; do
					topdirs+=( "${l}" )
				done < <(tar -t -f "${DISTDIR}/${f}" | cut -d/ -f1 | sort -u)
				if [[ ${#topdirs[@]} -gt 1 ]]; then
					eerror "The archive ${f} contains multiple or no top directory."
					eerror "It is impossible for vcs-snapshot to unpack this correctly."
					eerror "Top directories found:"
					local d
					for d in "${topdirs[@]}"; do
						eerror "    ${d}"
					done
					die "${FUNCNAME}: Invalid directory structure in archive ${f}"
				fi
				[[ ${topdirs[0]} != ${f%.tar*} ]] && renamed_any=1

				mkdir "${destdir}" || die
				# -o (--no-same-owner) to avoid restoring original owner
				einfo "Unpacking ${f}"
				tar -C "${destdir}" -x -o --strip-components 1 \
					-f "${DISTDIR}/${f}" || die
				;;
			*)
				debug-print "${FUNCNAME}: falling back to unpack for ${f}"

				# fall back to the default method
				unpack "${f}"
				;;
		esac
	done

	if [[ ! ${renamed_any} ]]; then
		eerror "${FUNCNAME} did not find any archives that needed renaming."
		eerror "Please verify that its usage is really necessary, and remove"
		eerror "the inherit if it is not."
		die "${FUNCNAME}: Unnecessary usage detected"
	fi
}

fi

EXPORT_FUNCTIONS src_unpack
