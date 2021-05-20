# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Spotify Web API client"
HOMEPAGE="
	https://tekore.readthedocs.io
	https://github.com/felix-hilden/tekore
"
SRC_URI="https://github.com/felix-hilden/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	>=dev-python/httpx-0.11[${PYTHON_USEDEP}]
	<dev-python/httpx-0.18[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	>=dev-python/pytest-asyncio-0.11[${PYTHON_USEDEP}]
	<dev-python/pytest-asyncio-0.15[${PYTHON_USEDEP}]
)"

DOCS="readme.rst"

distutils_enable_tests pytest
distutils_enable_sphinx docs/src \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinx-autodoc-typehints

python_prepare_all() {
	# requires network
	sed -i -e 's:test_bad_arguments_raises_error:_&:' \
			tests/auth/expiring.py || die

	distutils-r1_python_prepare_all
}
