# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Prints information and tests integrity of JPEG/JFIF files"
HOMEPAGE="https://www.kokkonen.net/tjko/projects.html"
SRC_URI="https://www.kokkonen.net/tjko/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="virtual/jpeg:0"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.6.0-parallel_install.patch )

src_configure() {
	tc-export CC
	econf
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README
}
