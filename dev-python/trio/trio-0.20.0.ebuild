# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python library for async concurrency and I/O"
HOMEPAGE="
	https://github.com/python-trio/trio
	https://pypi.org/project/trio
"
SRC_URI="
	https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/async_generator-1.9[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/outcome[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"
# NB: we're ignoring tests that require trustme+pyopenssl
BDEPEND="
	test? (
		>=dev-python/astor-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/immutables-0.6[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Times out on slower arches (ia64 in this case)
	# https://github.com/python-trio/trio/issues/1753
	trio/tests/test_unix_pipes.py::test_close_at_bad_time_for_send_all

	# incompatible ipython version?
	trio/_core/tests/test_multierror.py::test_ipython_exc_handler
)

EPYTEST_IGNORE=(
	# these tests require internet access
	trio/tests/test_ssl.py
	trio/tests/test_highlevel_ssl_helpers.py
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/immutables \
	dev-python/sphinxcontrib-trio \
	dev-python/sphinx_rtd_theme \
	dev-python/towncrier

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not redistributors_should_skip"
}
