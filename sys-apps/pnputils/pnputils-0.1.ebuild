# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Plug and Play BIOS utilities"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://archive.debian.org/debian/pool/main/p/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_compile() {
	emake CC="$(tc-getCC)" all
}

src_install () {
	emake DESTDIR="${ED}" install
	einstalldocs
}
