# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="substracts 2 mono wave files from each other by a factor specified on the command line"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
	"${FILESDIR}/${P}-overflow.patch"
)

DOCS=( CHANGES mono-stereo.txt README )

src_configure() {
	tc-export CC
}
