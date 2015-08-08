# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=1

inherit python-r1 autotools-utils

DESCRIPTION="Non-linear optimization library"
HOMEPAGE="http://ab-initio.mit.edu/nlopt/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="cxx guile octave python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
DEPEND="
	guile? ( dev-scheme/guile )
	octave? ( sci-mathematics/octave )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-pkgconfig.patch
	"${FILESDIR}"/${PN}-2.3-as-needed.patch
)

src_prepare() {
	autotools-utils_src_prepare
	use cxx && BUILD_CXX="${S}_cxx"
	use python && python_copy_sources
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
	)
	if use python; then
		python_foreach_impl run_in_build_dir autotools-utils_src_configure
	else
		autotools-utils_src_configure
	fi
	if use cxx; then
		myeconfargs+=( --with-cxx --without-octave --without-python )
		BUILD_DIR="${BUILD_CXX}" autotools-utils_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir autotools-utils_src_compile
	else
		autotools-utils_src_compile
	fi
	use cxx && BUILD_DIR="${BUILD_CXX}" autotools-utils_src_compile
	#-C "${BUILD_DIR}_cxx"
}

src_test() {
	do_test() {
		local a f
		cd "${BUILD_DIR}"/test
		for a in {1..7}; do
			for f in {5..9}; do
				./testopt -a $a -o $f || die "algorithm $a function $f failed"
			done
		done
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_test
	else
		do_test
	fi
	cd "${BUILD_CXX}"/test
	for a in {1..9}; do
		for f in {5..9}; do
			./testopt -a $a -o $f || die "algorithm $a function $f failed"
		done
	done
}

src_install() {
	# build cxx first so the c lib overwrites the pc file
	use cxx && BUILD_DIR="${BUILD_CXX}" autotools-utils_src_install
	if use python; then
		python_foreach_impl run_in_build_dir autotools-utils_src_install
	else
		autotools-utils_src_install
	fi
	local r
	for r in */README; do newdoc ${r} README.$(dirname ${r}); done
}
