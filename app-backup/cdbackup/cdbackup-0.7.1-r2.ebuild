# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Allows streaming backup utilities to dump/restore from CD-R(W)s or DVD(+/-RW)s"
HOMEPAGE="https://www.muempf.de/index.html"
SRC_URI="https://www.muempf.de/down/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-cdr/cdrtools-1.11.28"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-u_char-musl.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin cdbackup cdrestore
	doman cdbackup.1 cdrestore.1
	einstalldocs
}
