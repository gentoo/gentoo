# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vcs-snapshot.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @SUPPORTED_EAPIS: 0 1 2 3 4 5 6
# @BLURB: support eclass for unpacking VCS snapshot tarballs
# @DESCRIPTION:
# This eclass provides a convenience src_unpack() which does unpack all
# the tarballs in SRC_URI to locations matching their (local) names,
# discarding the original parent directory.
#
# The typical use case are VCS snapshots, coming from bitbucket
# and similar services. They have hash appended to the directory name
# which makes extracting them a painful experience. But if you just use
# a SRC_URI arrow to rename it (which you're likely have to do anyway),
# vcs-snapshot will just extract it into a matching directory.
#
# Please note that this eclass handles only tarballs (.tar, .tar.gz,
# .tar.bz2 & .tar.xz). For any other file format (or suffix) it will
# fall back to regular unpack. Support for additional formats may be
# added at some point so please keep your SRC_URIs clean.
#
# Note: this eclass is no longer needed with the new-style 'archive'
# GitHub URLs. They have sane directory names and stable contents,
# so you should really prefer them.
#
# @EXAMPLE:
#
# @CODE
# EAPI=6
# inherit vcs-snapshot
#
# SRC_URI="https://github.com/example/${PN}/tarball/v${PV} -> ${P}.tar.gz
# 	https://github.com/example/${PN}-otherstuff/tarball/v${PV} -> ${P}-otherstuff.tar.gz"
# @CODE
#
# and however the tarballs were originally packed, all files will appear
# in ${WORKDIR}/${P} and ${WORKDIR}/${P}-otherstuff respectively.

case ${EAPI:-0} in
	0|1|2|3|4|5|6) ;;
	*) die "vcs-snapshot.eclass API in EAPI ${EAPI} not yet established."
esac

EXPORT_FUNCTIONS src_unpack

# @FUNCTION: vcs-snapshot_src_unpack
# @DESCRIPTION:
# Extract all the archives from ${A}. The .tar, .tar.gz, .tar.bz2
# and .tar.xz archives will be unpacked to directories matching their
# local names. Other archive types will be passed down to regular
# unpack.
vcs-snapshot_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	local f

	for f in ${A}
	do
		case "${f}" in
			*.tar|*.tar.gz|*.tar.bz2|*.tar.xz)
				local destdir=${WORKDIR}/${f%.tar*}

				debug-print "${FUNCNAME}: unpacking ${f} to ${destdir}"

				# XXX: check whether the directory structure inside is
				# fine? i.e. if the tarball has actually a parent dir.
				mkdir "${destdir}" || die
				# -o (--no-same-owner) to avoid restoring original owner
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
}
