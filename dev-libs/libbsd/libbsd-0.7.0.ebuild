# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib

DESCRIPTION="An library to provide useful functions commonly found on BSD systems"
HOMEPAGE="http://libbsd.freedesktop.org/wiki/"
SRC_URI="http://${PN}.freedesktop.org/releases/${P}.tar.xz"

LICENSE="BSD BSD-2 BSD-4 ISC"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ppc ppc64 sparc x86"
IUSE="static-libs"

DOCS="ChangeLog README TODO"

pkg_setup() {
	local f="${ROOT}/usr/$(get_libdir)/${PN}.a"
	local m="You need to remove ${f} by hand or re-emerge sys-libs/glibc first."
	if ! has_version ${CATEGORY}/${PN}; then
		if [[ -e ${f} ]]; then
			eerror "${m}"
			die "${m}"
		fi
	fi
}

src_configure() {
	# The build system will install libbsd-ctor.a despite of USE="-static-libs"
	# which is correct, see:
	# http://cgit.freedesktop.org/libbsd/commit/?id=c5b959028734ca2281250c85773d9b5e1d259bc8
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
