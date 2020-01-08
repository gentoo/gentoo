# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple command-line based CD Player"
HOMEPAGE="http://www.technopagan.org/dcd"
SRC_URI="http://www.technopagan.org/dcd/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-Wimplicit-function-declaration.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDROM="/dev/cdrom" \
		EXTRA_CFLAGS="${CFLAGS}"
}

src_install() {
	dobin dcd
	einstalldocs
	doman dcd.1
}
