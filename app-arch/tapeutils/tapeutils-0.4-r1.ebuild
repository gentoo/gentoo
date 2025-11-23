# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utilities for manipulation of tapes and tape image files"
HOMEPAGE="http://www.brouhaha.com/~eric/software/tapeutils/"
SRC_URI="http://www.brouhaha.com/~eric/software/tapeutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="!app-emulation/hercules"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.4-fix-C-decl.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin tapecopy tapedump
	# no docs to install
}
