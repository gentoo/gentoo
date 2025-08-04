# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=plugins
PYTHON_COMPAT=( python3_{11..13} )
DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	media-gfx/graphviz
	media-libs/freetype
	virtual/latex-base
"

inherit autotools docs fortran-2 python-single-r1

DESCRIPTION="A software package for jet finding in pp and e+e- collisions"
HOMEPAGE="https://fastjet.fr/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/fastjet/fastjet"
else
	SRC_URI="https://fastjet.fr/repo/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="cgal examples python +plugins"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# cgal is header-only in version 5.4 and up. We need to use the
# special --enable-cgal-header-only argument to use these versions.
DEPEND="
	cgal? ( >=sci-mathematics/cgal-5.4:=[shared(+)] )
	plugins? ( sci-physics/siscone:= )
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"
RDEPEND="${DEPEND}"
BDEPEND="app-shells/bash"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0-system-siscone.patch
	"${FILESDIR}"/${PN}-3.4.0-gfortran.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	fortran-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# only bash compatible
	local -x CONFIG_SHELL="${BROOT}/bin/bash"
	local myeconfargs=(
		"$(use_enable cgal cgal-header-only)"
		"$(use_enable plugins monolithic)"
		"$(use_enable plugins allplugins)"
		"$(use_enable plugins allcxxplugins)"
		"--enable-shared"
		"--enable-static=no"
		"--disable-static"
		"--disable-auto-ptr"
		"$(use_enable python pyext)"
		"$(use_enable python swig)"
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	docs_compile
}

src_install() {
	default
	use python && python_optimize
	if use examples; then
		emake -C example maintainer-clean
		find example -iname 'makefile*' -delete || die

		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	find "${ED}" -name '*.la' -delete || die
}
