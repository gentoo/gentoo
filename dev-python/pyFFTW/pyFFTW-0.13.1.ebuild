# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="A pythonic python wrapper around FFTW"
HOMEPAGE="
	https://github.com/pyFFTW/pyFFTW/
	https://pypi.org/project/pyFFTW/
"
SRC_URI="
	https://github.com/pyFFTW/pyFFTW/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	>=sci-libs/fftw-3.3:3.0=[threads]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/cython-0.29.18[${PYTHON_USEDEP}]
	test? (
		>=dev-python/dask-1.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.8.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_configure() {
	# otherwise it'll start with -L/usr/lib, sigh
	export PYFFTW_INCLUDE_DIR="${EPREFIX}/usr/include"
	export PYFFTW_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
}

python_test() {
	cp -r -l -n tests/ "${BUILD_DIR}/lib" || die
	cd "${BUILD_DIR}/lib" || die
	eunittest
	rm -r tests/ || die
}
