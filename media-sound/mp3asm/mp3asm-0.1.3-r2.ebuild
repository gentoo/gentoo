# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV}-1"  # Patchlevel

DESCRIPTION="A command line tool to clean and edit mp3 files"
HOMEPAGE="https://sourceforge.net/projects/mp3asm/"
SRC_URI="mirror://sourceforge/mp3asm/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

# the author uses weird numbering...
S="${WORKDIR}/${PN}-0.1"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/mp3asm
	dodoc Changelog README
}
