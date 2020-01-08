# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Compute Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/gmp:0=[cxx]
	sci-libs/cddlib:0="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/"

PATCHES=(
	"${FILESDIR}"/${P}-double-declare-fix.patch
	"${FILESDIR}"/${P}-gcc6.1-compat.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-fix-gcc9.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}
