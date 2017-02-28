# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="computes Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-libs/gmp[cxx]
	sci-libs/cddlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/"

PATCHES=(
	"${FILESDIR}/${P}-double-declare-fix.patch"
	"${FILESDIR}/${P}-gcc6.1-compat.patch"
	)

src_prepare () {
	default
	sed -i -e "s/-O2/${CXXFLAGS}/" \
		-e "/GPROFFLAG =/d" \
		-e "s/g++/$(tc-getCXX)/" \
		-e "s/\$(CCLINKER)/& \$(LDFLAGS)/" Makefile || die
}

src_install() {
	emake PREFIX="${ED}/usr" install
}
