# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Minimal Abstraction Layer for Object-oriented C/C++ programs"
HOMEPAGE="http://www.fetk.org/codes/maloc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"
S="${WORKDIR}/${PN}"

SLOT="0"
LICENSE="GPL-2"
IUSE="doc mpi"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
RDEPEND="
	sys-libs/readline:0=
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-mpi.patch
	"${FILESDIR}"/${PN}-1.4-asneeded.patch
	"${FILESDIR}"/${PN}-1.4-doc.patch
)

src_prepare() {
	default

	echo 'VPUBLIC int Vio_getc(Vio *thee){  ASC *asc; asc = thee->axdr; return asc->buf[asc->pos++];  }' >> src/vsys/vio.c || die
	eautoreconf
}

src_configure() {
	local myeconfargs=()

	use mpi && export CC="mpicc"
	use doc || myeconfargs+=( --with-doxygen= --with-dot= )

	myeconfargs+=(
		--disable-triplet
		--disable-static
		$(use_enable mpi)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	docinto html
	dodoc doc/index.html

	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name '*.a' -delete || die
}
