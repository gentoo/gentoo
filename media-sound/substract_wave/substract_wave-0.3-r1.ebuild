# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Substracts 2 mono wave files from each other by a factor specified"
HOMEPAGE="https://www.panteltje.nl/panteltje/dvd/"
SRC_URI="https://www.panteltje.nl/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
	"${FILESDIR}/${P}-overflow.patch"
)

DOCS=( CHANGES mono-stereo.txt README )

src_configure() {
	tc-export CC
}
