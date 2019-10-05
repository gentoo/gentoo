# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="HTML Include System by Ulli Meybohm"
HOMEPAGE="http://www.meybohm.de/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86 ~x86-linux ~ppc-macos ~x86-macos"

S="${WORKDIR}/${PN}"
PATCHES=(
	"${FILESDIR}"/${PN}-gcc3-gentoo.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
)

src_configure() {
	tc-export CXX
	append-cxxflags -Wall
}

src_install() {
	dobin htmlinc
	einstalldocs
}
