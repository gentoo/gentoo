# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

DESCRIPTION="2D/3D AFEM code for nonlinear geometric PDE"
HOMEPAGE="http://fetk.org/codes/mc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug doc"

RDEPEND="
	dev-libs/maloc
	media-libs/sg
	sci-libs/amd
	sci-libs/gamer
	sci-libs/punc
	<sci-libs/superlu-5
	sci-libs/umfpack
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

PATCHES=(
	"${FILESDIR}"/1.4-superlu.patch
	"${FILESDIR}"/1.4-overflow.patch
	"${FILESDIR}"/1.4-multilib.patch
	"${FILESDIR}"/1.4-doc.patch
	"${FILESDIR}"/${P}-unbundle.patch
)

src_prepare() {
	default
	sed \
		-e 's:AMD_order:amd_order:g' \
		-e 's:UMFPACK_numeric:umfpack_di_numeric:g' \
		-e 's:buildg_:matvec_:g' \
		-i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug vdebug) \
		$(usex doc '' '--with-doxygen= --with-dot=')
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
