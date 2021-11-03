# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="A pythonic python wrapper around FFTW"
HOMEPAGE="https://github.com/pyFFTW/pyFFTW"

LICENSE="BSD"
SLOT="0"
if [[ "${PV}" = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pyFFTW/pyFFTW.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pyFFTW/pyFFTW/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/fftw-3.3:3.0=[threads]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/dask[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	cp -r -l -n test/ "${BUILD_DIR}/lib" || die
	cd "${BUILD_DIR}/lib" || die
	eunittest
	rm -r test/ || die
}
