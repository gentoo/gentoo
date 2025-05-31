# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12,13} )

DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1 pypi

DESCRIPTION="A Python library in building OAuth and OpenID Connect servers and clients."

HOMEPAGE="https://authlib.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="django flask jose test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	django? (
		dev-python/django[${PYTHON_USEDEP}]
	)
	flask? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	)
	jose? (
		>=dev-python/pycryptodome-3.10[${PYTHON_USEDEP}]
		<dev-python/pycryptodome-4[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/anyio[${PYTHON_USEDEP}]
		dev-python/cachelib[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest
}
