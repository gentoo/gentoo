# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Compatibility layer for multiple asynchronous event loop implementations"
HOMEPAGE="
	https://github.com/agronholm/anyio
	https://pypi.org/project/anyio/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/idna-2.8[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.1[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/hypothesis-4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		>=dev-python/uvloop-0.15[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinx-autodoc-typehints

python_prepare_all() {
	# This will pull in dev-python/trio and a whole bunch of other new things
	# And trio does not yet have a release compatible with python3.9.
	rm tests/test_taskgroups.py || die
	sed -i -e '/trio/d' tests/conftest.py || die
	sed -i -e 's/test_cancel_scope_in_asyncgen_fixture/_&/' \
		-e 's/test_autouse_async_fixture/_&/' \
		-e 's/test_plugin/_&/' \
		tests/test_pytest_plugin.py || die

	# skip network test
	sed -i -e 's/test_getaddrinfo/_&/' tests/test_sockets.py || die

	distutils-r1_python_prepare_all
}
