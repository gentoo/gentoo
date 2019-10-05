# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ongoing 'King of the Hill' (KotH) tournament"
HOMEPAGE="http://www.gamerz.net/c++robots/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	dobin combat cylon target tracker
	einstalldocs
}
