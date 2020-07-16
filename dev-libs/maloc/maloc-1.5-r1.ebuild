# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Minimal Abstraction Layer for Object-oriented C/C++ programs"
HOMEPAGE="http://www.fetk.org/codes/maloc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE="doc mpi static-libs"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sys-libs/readline:0=
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
		)"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/1.4-mpi.patch
	"${FILESDIR}"/1.4-asneeded.patch
	"${FILESDIR}"/1.4-doc.patch
	)

src_prepare() {
	echo 'VPUBLIC int Vio_getc(Vio *thee){  ASC *asc; asc = thee->axdr; return asc->buf[asc->pos++];  }' >> src/vsys/vio.c || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs
	use mpi && export CC="mpicc"
	use doc || myeconfargs+=( --with-doxygen= --with-dot= )

	myeconfargs+=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable mpi)
		--disable-triplet
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# install doc
	dohtml doc/index.html
}
