# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="TFTP client suitable for uploading to the Linksys WRT54G Wireless Router"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://www.redsand.net/solutions/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"

PATCHES=(
	"${FILESDIR}/${P}-r1-header.patch"
	"${FILESDIR}/${P}-r1-Makefile.patch"
	"${FILESDIR}/${P}-r1-fno-common.patch"
	"${FILESDIR}/${P}-r1-clang.patch"
	"${FILESDIR}/${P}-r4-c99-port.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin linksys-tftp
	einstalldocs
}
