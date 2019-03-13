# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MYP=ParMGridGen-${PV}

DESCRIPTION="Software for parallel (mpi) generating coarse grids"
HOMEPAGE="http://www-users.cs.umn.edu/~moulitsa/software.html"
SRC_URI="http://www-users.cs.umn.edu/~moulitsa/download/${MYP}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RESTRICT="mirror bindist"

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MYP}

pkg_setup(){
	export CC=mpicc
}

PATCHES=(
	"${FILESDIR}/${P}-autotools.patch"
	"${FILESDIR}/${P}-as-needed.patch"
	"${FILESDIR}/${P}-format-security.patch"
	"${FILESDIR}/${P}-impl-fct.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	dodoc README Doc/*.pdf
}
