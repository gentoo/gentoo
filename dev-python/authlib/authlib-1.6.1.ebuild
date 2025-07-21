# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="A Python library in building OAuth and OpenID Connect servers and clients"
HOMEPAGE="
	https://authlib.org/
	https://github.com/authlib/authlib/
	https://pypi.org/project/Authlib/
"
# pypi source distribution excludes the tests
SRC_URI="
	https://github.com/authlib/authlib/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

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
	)
"
BDEPEND="
	test? (
		dev-python/anyio[${PYTHON_USEDEP}]
		dev-python/cachelib[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		>=dev-python/pycryptodome-3.10[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# convert from pycryptodomex to pycryptodome
	sed -i -e 's:from Cryptodome:from Crypto:' \
		authlib/jose/drafts/_jwe_enc_cryptodome.py || die
}

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.clients.test_django.settings
	epytest tests/{core,jose,clients,flask}

	# TODO: django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet.
	#local -x DJANGO_SETTINGS_MODULE=tests.django.settings
	#epytest tests/django
}
