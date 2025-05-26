# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Concatenates any number of audio files to stdout"
HOMEPAGE="https://www.panteltje.nl/panteltje/dvd/"
SRC_URI="https://www.panteltje.nl/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-version.patch
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-c23.patch
)

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_install() {
	dobin pwavecat
	einstalldocs
}
