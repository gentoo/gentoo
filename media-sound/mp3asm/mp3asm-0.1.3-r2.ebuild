# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV="${PV}-1" # Patchlevel

DESCRIPTION="Command line tool to clean and edit mp3 files"
HOMEPAGE="https://sourceforge.net/projects/mp3asm/"
SRC_URI="mirror://sourceforge/mp3asm/${PN}-${MY_PV}.tar.bz2"
S="${WORKDIR}/${PN}-0.1" # the author uses weird numbering...

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-fix-autotools.patch
	"${FILESDIR}"/${P}-log.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	dodoc Changelog
}
