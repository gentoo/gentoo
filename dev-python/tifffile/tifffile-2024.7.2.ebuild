# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x SKIP_LARGE=1
	local -x SKIP_HTTP=1

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
