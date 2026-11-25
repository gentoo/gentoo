# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Python library to read from and write to FITS files"
HOMEPAGE="
	https://github.com/esheldon/fitsio/
	https://pypi.org/project/fitsio/
"
SRC_URI="
	https://github.com/esheldon/fitsio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/numpy-1.17:=[${PYTHON_USEDEP}]
	>=sci-libs/cfitsio-4.6.4:0=
"
RDEPEND="
	${DEPEND}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export FITSIO_USE_SYSTEM_FITSIO=1

python_test() {
	local EPYTEST_DESELECT=(
		# requires pytest-run-parallel
		fitsio/tests/test_locking.py::test_locking_io
		# requires cfitsio built without FMA instructions
		# https://github.com/esheldon/fitsio/issues/512
		fitsio/tests/test_image_compression.py::test_image_compression_read_from_osx_arm64
		fitsio/tests/test_image_compression.py::test_image_compression_write_read_comp_to_osx_arm64
	)

	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}
