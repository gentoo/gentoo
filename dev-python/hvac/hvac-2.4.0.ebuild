# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYPI_VERIFY_REPO=https://github.com/hvac/hvac
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="HashiCorp Vault API client"
HOMEPAGE="
	https://github.com/hvac/hvac/
	https://pypi.org/project/hvac/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/pyhcl-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/jwcrypto[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/semantic-version[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-mock requests-mock )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# ldap_test is not packaged.
		tests/integration_tests/api/auth_methods/test_ldap.py
		# https://github.com/lepture/authlib is not packaged.
		tests/integration_tests/api/auth_methods/test_oidc.py
	)

	epytest -o addopts=
}
