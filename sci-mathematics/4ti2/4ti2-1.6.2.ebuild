# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/4ti2/4ti2-1.6.2.ebuild,v 1.5 2015/03/22 11:17:18 nativemad Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true
# The swig subdir is not used, so we can skip running autotools in it. #518000
AT_NO_RECURSIVE=1

inherit autotools-utils

DESCRIPTION="Software package for algebraic, geometric and combinatorial problems"
HOMEPAGE="http://www.4ti2.de/"
SRC_URI="http://4ti2.de/version_${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-macos"
IUSE="static-libs"

DEPEND="
	sci-mathematics/glpk:0[gmp]
	dev-libs/gmp[cxx]"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2-gold.patch
	)

src_prepare() {
	sed \
		-e "s:^CXX.*$:CXX=$(tc-getCXX):g" \
		-i m4/glpk-check.m4 || die
	autotools-utils_src_prepare
}
