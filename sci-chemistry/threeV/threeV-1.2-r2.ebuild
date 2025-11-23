# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="3V: Voss Volume Voxelator"
HOMEPAGE="http://geometry.molmovdb.org/3v/"
SRC_URI="http://geometry.molmovdb.org/3v/3v-${PV}.tgz"
S=${WORKDIR}/3v-${PV}/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

PDEPEND="sci-chemistry/msms-bin"
#	sci-chemistry/usf-rave"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-format-security.patch
)

DOCS=( ../AUTHORS ../ChangeLog ../QUICKSTART ../README ../TODO ../VERSION )

src_prepare() {
	default
	tc-export CXX
	emake distclean

	export MAKEOPTS+=" V=1"
}
