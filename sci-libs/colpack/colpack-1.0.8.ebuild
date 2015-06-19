# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/colpack/colpack-1.0.8.ebuild,v 1.3 2012/09/17 22:03:38 bicatali Exp $

EAPI=4

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

inherit eutils toolchain-funcs autotools-utils

MYPN=ColPack

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
LICENSE="GPL-3 LGPL-3"
HOMEPAGE="http://www.cscapes.org/coloringpage/software.htm"
SRC_URI="http://www.cscapes.org/download/${MYPN}/${MYPN}-${PV}.tar.gz"

SLOT="0"
IUSE="openmp static-libs"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.6-flags.patch
	"${FILESDIR}"/${PN}-1.0.8-no-bin.patch
)

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
		ewarn "You are using gcc without OpenMP"
		die "Need an OpenMP capable compiler"
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
