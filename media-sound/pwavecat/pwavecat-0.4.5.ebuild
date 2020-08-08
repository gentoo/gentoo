# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="concatenates any number of audio files to stdout"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-version.patch
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_install() {
	dobin pwavecat
	einstalldocs
}
