# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.* *-jython 2.7-pypy-*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit eutils flag-o-matic multilib python versionator

MY_P="${PN}-$(delete_version_separator 2)_release"

DESCRIPTION="Real-time 3D graphics library for Python"
HOMEPAGE="http://www.vpython.org/"
SRC_URI="http://www.vpython.org/contents/download/${MY_P}.tar.bz2"

LICENSE="HPND Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples"

RDEPEND=">=dev-cpp/gtkglextmm-1.2
	dev-cpp/libglademm
	>=dev-libs/boost-1.48[python]
	dev-python/numpy
	dev-python/polygon:2
	dev-python/ttfquery"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Verbose build.
	sed -i \
		-e 's/2\?>>[[:space:]]*\$(LOGFILE).*//' \
		src/Makefile.in || die

	epatch "${FILESDIR}/${P}-boost-1.50.patch"

	python_clean_py-compile_files
	python_src_prepare

	preparation() {
		sed -i \
			-e "s/-lboost_python/-lboost_python-${PYTHON_ABI}/" \
			-e "s/libboost_python/libboost_python-${PYTHON_ABI}/" \
			src/Makefile.in src/gtk2/makefile
	}
	python_execute_function -s preparation
}

src_configure() {
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.48")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_INC="${EPREFIX}/usr/include/boost-${BOOST_VER}"
	BOOST_LIB="${EPREFIX}/usr/$(get_libdir)/boost-${BOOST_VER}"

	# Specify the include and lib directory for Boost.
	append-cxxflags -I${BOOST_INC}
	append-ldflags -L${BOOST_LIB}

	python_src_configure \
		--with-example-dir="${EPREFIX}/usr/share/doc/${PF}/examples" \
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html" \
		$(use_enable doc docs) \
		$(use_enable examples)
}

src_install() {
	python_src_install
	python_clean_installation_image

	dodoc authors.txt HACKING.txt NEWS.txt
}

pkg_postinst() {
	python_mod_optimize vis visual
}

pkg_postrm() {
	python_mod_cleanup vis visual
}
