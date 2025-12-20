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

inherit cmake docs fortran-2 python-single-r1

DESCRIPTION="A software package for jet finding in pp and e+e- collisions"
HOMEPAGE="https://fastjet.fr/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/fastjet/fastjet"
else
	SRC_URI="https://fastjet.fr/repo/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="cgal examples python +plugins"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) examples? ( plugins )"

# cgal is header-only in version 5.4 and up. We need to use the
# special --enable-cgal-header-only argument to use these versions.
DEPEND="
	cgal? ( >=sci-mathematics/cgal-5.4:=[shared(+)] )
	plugins? ( >=sci-physics/siscone-3.1.2-r1:= )
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DFASTJET_ENABLE_CGAL=$(usex cgal)
		-DFASTJET_ENABLE_ALLPLUGINS=$(usex plugins)
		-DFASTJET_ENABLE_ALLCXXPLUGINS=$(usex plugins)
		-DFASTJET_ENABLE_PYTHON=$(usex python)
		-DFASTJET_BUILD_EXAMPLES=$(usex examples)
		-DFASTJET_HAVE_AUTO_PTR_INTERFACE=OFF
		-DFASTJET_USE_INSTALLED_SISCONE=ON
	)
	use python && mycmakeargs+=(
		-DFASTJET_CUSTOM_PYTHON_INSTALL="$(python_get_sitedir)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install
	use python && python_optimize
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	find "${ED}" -name '*.la' -delete || die
}
