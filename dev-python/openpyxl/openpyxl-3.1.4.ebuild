# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="
	https://openpyxl.readthedocs.io/en/stable/
	https://foss.heptapod.net/openpyxl/openpyxl/
"
SRC_URI="
	https://foss.heptapod.net/openpyxl/openpyxl/-/archive/${PV}/${P}.tar.bz2
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/et-xmlfile[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/lxml-5.0.3[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff,jpeg]
	)
"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# https://foss.heptapod.net/openpyxl/openpyxl/-/issues/2187
	sed -i -e 's:float_:float64:' openpyxl/compat/tests/test_compat.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# GC assumptions (pypy)
		openpyxl/tests/test_iter.py::test_file_descriptor_leak
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
