# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="3V: Voss Volume Voxelator"
HOMEPAGE="http://geometry.molmovdb.org/3v/"
SRC_URI="http://geometry.molmovdb.org/3v/3v-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PDEPEND="sci-chemistry/msms-bin"
#	sci-chemistry/usf-rave"

S="${WORKDIR}/3v-${PV}/src"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default
	tc-export CXX
	emake distclean

	export MAKEOPTS+=" V=1"
}

src_install() {
	emake DESTDIR="${ED}" install

	cd .. || die
	dodoc AUTHORS ChangeLog QUICKSTART README TODO VERSION
}
