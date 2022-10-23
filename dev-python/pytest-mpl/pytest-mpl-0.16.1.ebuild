# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Facilitate image comparison for Matplotlib figures"
HOMEPAGE="
	https://pypi.org/project/pytest-mpl/
	https://github.com/matplotlib/pytest-mpl
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	tests/subtests/test_subtest.py::test_default
	tests/subtests/test_subtest.py::test_html_images_only
)

distutils_enable_tests pytest

python_test() {
	# disable autoloading plugins in nested pytest calls
	#local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# since we disabled autoloading, force loading necessary plugins
	#local -x PYTEST_PLUGINS=xdist.plugin,xdist.looponfail,pytest_forked

	epytest
}
