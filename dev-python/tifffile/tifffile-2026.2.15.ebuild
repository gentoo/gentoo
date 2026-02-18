# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Read and write TIFF files"
HOMEPAGE="
	https://pypi.org/project/tifffile/
	https://github.com/cgohlke/tifffile/
	https://www.cgohlke.com/
"
SRC_URI="
	https://github.com/cgohlke/tifffile/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/numpy-1.19.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/defusedxml[${PYTHON_USEDEP}]
		>=dev-python/fsspec-2021.5.0[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# not marked properly
		# https://github.com/cgohlke/tifffile/pull/308
		tests/test_tifffile.py::test_issue_dcp
		# meaningless and broken on py<3.13
		# https://github.com/cgohlke/tifffile/pull/309
		tests/test_tifffile.py::test_gil_enabled
	)

	local -x SKIP_LARGE=1
	local -x SKIP_HTTP=1

	epytest
}
