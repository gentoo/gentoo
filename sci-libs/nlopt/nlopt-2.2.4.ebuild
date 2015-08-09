# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="python? *"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit python autotools-utils

DESCRIPTION="Non-linear optimization library"
HOMEPAGE="http://ab-initio.mit.edu/nlopt/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="cxx guile octave python static-libs"

DEPEND="
	guile? ( dev-scheme/guile )
	octave? ( sci-mathematics/octave )
	python? ( dev-python/numpy )"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	if use python; then
		sed -i \
			-e '/^LTLIBRARIES/s:$(pyexec_LTLIBRARIES)::g' \
			swig/Makefile.in || die
		echo '#!/bin/sh' > py-compile
	fi
	epatch "${FILESDIR}"/${P}-fix-nlopt_hpp-location.patch
	eautoreconf
}

src_configure() {
	if use octave; then
		export OCT_INSTALL_DIR="${EPREFIX}"/usr/libexec/octave/site/oct/${CHOST}
		export M_INSTALL_DIR="${EPREFIX}"/usr/share/octave/site/m
	else
		export MKOCTFILE=None
	fi
	myeconfargs+=(
		$(use_with cxx)
		$(use_with guile)
		$(use_with octave)
		$(use_with python)
		--without-matlab
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use python; then
		python_copy_sources swig
		compilation() {
			autotools-utils_src_compile \
				PYTHON_CPPFLAGS="-I${EPREFIX}$(python_get_includedir)" \
				PYTHON_LDFLAGS="${EPREFIX}$(python_get_library -l)" \
				PYTHON_SITE_PKG="${EPREFIX}$(python_get_sitedir)" \
				PYTHON_VERSION="${EPREFIX}$(python_get_version)" \
				PYTHON_INCLUDES="${EPREFIX}$(python_get_includedir)" \
				pythondir="${EPREFIX}$(python_get_sitedir)" \
				pyexecdir="${EPREFIX}$(python_get_sitedir)"
		}
		python_execute_function -s --source-dir swig compilation
	fi
}

src_install() {
	autotools-utils_src_install
	if use python; then
		installation() {
			rm *.la
			emake DESTDIR="${D}" install \
				pyexecdir="${EPREFIX}$(python_get_sitedir)" \
				pythondir="${EPREFIX}$(python_get_sitedir)"
		}
		python_execute_function -s --source-dir swig installation
		python_clean_installation_image
	fi
	local r
	for r in */README; do newdoc ${r} README.$(dirname ${r}); done
}

pkg_postinst() {
	use python && python_mod_optimize ${PN}.py
}

pkg_postrm() {
	use python && python_mod_cleanup ${PN}.py
}
