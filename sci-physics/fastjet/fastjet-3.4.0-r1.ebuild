# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=plugins
PYTHON_COMPAT=( python3_{9..11} )
DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	media-gfx/graphviz
	media-libs/freetype
	virtual/latex-base
"

inherit autotools docs flag-o-matic fortran-2 python-single-r1

DESCRIPTION="A software package for jet finding in pp and e+e- collisions"
HOMEPAGE="https://fastjet.fr/"
SRC_URI="https://fastjet.fr/repo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cgal examples python +plugins"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# cgal is header-only in version 5.4 and up. We need to use the
# special --enable-cgal-header-only argument to use these versions.
DEPEND="
	cgal? ( >=sci-mathematics/cgal-5.4:=[shared(+)] )
	plugins? ( sci-physics/siscone:= )
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/fortran"

PATCHES=(
	"${FILESDIR}"/${P}-system-siscone.patch
	"${FILESDIR}"/${P}-gfortran.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use cgal && \
		has_version 'sci-mathematics/cgal[gmp]' && append-libs -lgmp

	econf \
		$(use_enable cgal cgal-header-only) \
		$(use_enable plugins allplugins) \
		$(use_enable plugins allcxxplugins) \
		--enable-shared \
		--enable-static=no \
		--disable-static \
		--disable-auto-ptr  \
		$(use_enable python pyext)
}

src_compile() {
	default
	docs_compile
}

src_install() {
	default
	if use examples; then
		emake -C example maintainer-clean
		find example -iname 'makefile*' -delete || die

		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	find "${ED}" -name '*.la' -delete || die
}
