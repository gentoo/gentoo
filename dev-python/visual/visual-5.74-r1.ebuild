# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic multilib python-single-r1 versionator

MY_P="${PN}-$(delete_version_separator 2)_release"

DESCRIPTION="Real-time 3D graphics library for Python"
HOMEPAGE="http://www.vpython.org/"
SRC_URI="http://www.vpython.org/contents/download/${MY_P}.tar.bz2"

LICENSE="HPND Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-cpp/gtkglextmm-1.2
	dev-cpp/libglademm
	>=dev-libs/boost-1.48:=[threads,python,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/polygon:2[${PYTHON_USEDEP}]
	dev-python/ttfquery[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Verbose build.
	sed -i \
		-e 's/2\?>>[[:space:]]*\$(LOGFILE).*//' \
		src/Makefile.in || die

	epatch "${FILESDIR}/${P}-boost-1.50.patch"

	sed \
		-e "s/-lboost_python/-lboost_python-${EPYTHON#python}/" \
		-e "s/libboost_python/libboost_python-${EPYTHON#python}/" \
		-i src/Makefile.in src/gtk2/makefile || die
}

src_configure() {
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.48")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_INC="${EPREFIX}/usr/include/boost-${BOOST_VER}"
	BOOST_LIB="${EPREFIX}/usr/$(get_libdir)/boost-${BOOST_VER}"

	# Specify the include and lib directory for Boost.
	append-cxxflags -I${BOOST_INC} -std=c++11
	append-ldflags -L${BOOST_LIB}

	econf \
		--with-example-dir="${EPREFIX}/usr/share/doc/${PF}/examples" \
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html" \
		$(use_enable doc docs) \
		$(use_enable examples)
}

src_install() {
	default

	dodoc authors.txt HACKING.txt NEWS.txt
}
