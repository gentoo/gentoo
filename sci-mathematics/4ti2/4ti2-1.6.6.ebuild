# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true
# The swig subdir is not used, so we can skip running autotools in it. #518000
AT_NO_RECURSIVE=1

inherit autotools-utils toolchain-funcs

DESCRIPTION="Software package for algebraic, geometric and combinatorial problems"
HOMEPAGE="http://www.4ti2.de/"
SRC_URI="http://4ti2.de/version_${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
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
