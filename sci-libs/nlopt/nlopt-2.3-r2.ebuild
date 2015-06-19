# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/nlopt/nlopt-2.3-r2.ebuild,v 1.3 2013/04/24 12:20:01 jlec Exp $

EAPI=5

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="python? *"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"
AUTOTOOLS_AUTORECONF=1

inherit  autotools-utils python

DESCRIPTION="Non-linear optimization library"
HOMEPAGE="http://ab-initio.mit.edu/nlopt/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="cxx guile octave python static-libs"

DEPEND="
	guile? ( dev-scheme/guile )
	octave? ( sci-mathematics/octave )
	python? ( dev-python/numpy )"
RDEPEND="${DEPEND}"

PATCHES=(
		"${FILESDIR}"/${PN}-2.2.4-fix-nlopt_hpp-location.patch
		"${FILESDIR}"/${PN}-2.3-pkgconfig.patch
		"${FILESDIR}"/${PN}-2.3-as-needed.patch
)

src_prepare() {
	sed \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g' \
		-i configure.ac || die
	autotools-utils_src_prepare
	if use python; then
		sed -i \
			-e '/^LTLIBRARIES/s:$(pyexec_LTLIBRARIES)::g' \
			swig/Makefile.in || die
		echo '#!/bin/sh' > py-compile
	fi
	use python && python_src_prepare
}

src_configure() {
	if use octave; then
		export OCT_INSTALL_DIR="$(octave-config -p LOCALOCTFILEDIR)"
		export M_INSTALL_DIR="$(octave-config -p LOCALFCNFILEDIR)"

	else
		export MKOCTFILE=None
	fi
	local myeconfargs=(
		$(use_with guile)
		$(use_with octave)
		$(use_with python)
	)
	autotools-utils_src_configure
	if use cxx; then
		myeconfargs+=( --with-cxx )
		BUILD_DIR="${BUILD_DIR}_cxx" autotools-utils_src_configure
	fi
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
	use cxx && autotools-utils_src_compile -C "${BUILD_DIR}_cxx"
}

src_test() {
	local a f
	cd "${BUILD_DIR}"/test
	for a in {1..7}; do
		for f in {5..9}; do
			./testopt -a $a -o $f || die "algorithm $a function $f failed"
		done
	done
	cd "${BUILD_DIR}_cxx"/test
	for a in {1..9}; do
		for f in {5..9}; do
			./testopt -a $a -o $f || die "algorithm $a function $f failed"
		done
	done
}

src_install() {
	# build cxx first so the c lib overwrites the pc file
	use cxx && autotools-utils_src_install -C "${BUILD_DIR}_cxx"
	autotools-utils_src_install
	if use python; then
		installation() {
			cd "${AUTOTOOLS_BUILD_DIR}"
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
