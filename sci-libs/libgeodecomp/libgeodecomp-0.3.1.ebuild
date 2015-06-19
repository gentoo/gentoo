# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libgeodecomp/libgeodecomp-0.3.1.ebuild,v 1.3 2015/05/06 05:35:19 slis Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="http://www.libgeodecomp.org"
SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/boost-1.48"
DEPEND="${RDEPEND}
	dev-libs/libflatarray"

S="${WORKDIR}/${P}/src"

src_prepare() {
	epatch "${FILESDIR}/libflatarray.patch"
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doc
}

src_install() {
	DOCS=( ../README )
	use doc && HTML_DOCS=( ../doc/html/* )
	cmake-utils_src_install
}

src_test() {
	cmake-utils_src_make test
}