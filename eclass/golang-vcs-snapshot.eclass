# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: golang-vcs-snapshot.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @BLURB: support eclass for unpacking VCS snapshot tarballs for
# software written in the Go programming language
# @DESCRIPTION:
# This eclass provides a convenience src_unpack() which unpacks the
# first tarball mentioned in SRC_URI to its appropriate location in
# ${WORKDIR}/${P}, treating ${WORKDIR}/${P} as a go workspace.
#
# The location where the tarball is extracted is defined as
# ${WORKDIR}/${P}/src/${EGO_PN}.
#
# The typical use case is VCS snapshots coming from github, bitbucket
# and similar services.
#
# Please note that this eclass currently handles only tarballs
# (.tar.gz), but support for more formats may be added in the future.
#
# @EXAMPLE:
#
# @CODE
# EGO_PN=github.com/user/package
# inherit golang-vcs-snapshot
#
# SRC_URI="http://github.com/example/${PN}/tarball/v${PV} -> ${P}.tar.gz"
# @CODE
#
# The above example will extract the tarball to
# ${WORKDIR}/${P}/src/github.com/user/package

inherit golang-base

case ${EAPI:-0} in
	5) ;;
	*) die "${ECLASS} API in EAPI ${EAPI} not yet established."
esac

EXPORT_FUNCTIONS src_unpack

# @FUNCTION: golang-vcs-snapshot_src_unpack
# @DESCRIPTION:
# Extract the first archive from ${A} to the appropriate location for GOPATH.
golang-vcs-snapshot_src_unpack() {
	local x
	ego_pn_check
	set -- ${A}
	x="$1"
	mkdir -p "${WORKDIR}/${P}/src/${EGO_PN%/...}" || die
	tar -C "${WORKDIR}/${P}/src/${EGO_PN%/...}" -x --strip-components 1 \
		-f "${DISTDIR}/${x}" || die
}
