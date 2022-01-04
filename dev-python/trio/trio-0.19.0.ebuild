# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python library for async concurrency and I/O"
HOMEPAGE="
	https://github.com/python-trio/trio
	https://pypi.org/project/trio
"
SRC_URI="https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
		dev-python/ipython[${PYTHON_USEDEP}]
		>=dev-python/jedi-0.18.0[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-python3.10.patch
)

EPYTEST_DESELECT=(
	# Times out on slower arches (ia64 in this case)
	# https://github.com/python-trio/trio/issues/1753
	trio/tests/test_unix_pipes.py::test_close_at_bad_time_for_send_all

	# Fail with Python 3.10 on 'IPPROTO_MPTCP'
	# Everything else passes and this is a simple check for exported symbols
	# Let's try again with the next release (after 0.19.0).
	trio/tests/test_exports.py::test_static_tool_sees_all_symbols
)

EPYTEST_IGNORE=(
	# these tests require internet access
	trio/tests/test_ssl.py
	trio/tests/test_highlevel_ssl_helpers.py
)

distutils_enable_tests --install pytest
distutils_enable_sphinx docs/source \
					dev-python/immutables \
					dev-python/sphinxcontrib-trio \
					dev-python/sphinx_rtd_theme \
					dev-python/towncrier
