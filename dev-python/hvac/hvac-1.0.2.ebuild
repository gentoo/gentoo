# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="hashicorp vault client in python"
HOMEPAGE="https://github.com/hvac/hvac"
SRC_URI="https://github.com/hvac/hvac/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pyhcl-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/jwcrypto[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/semantic_version[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# ldap_test is not packaged.
	tests/integration_tests/api/auth_methods/test_ldap.py
	# https://github.com/lepture/authlib is not packaged.
	tests/integration_tests/api/auth_methods/test_oidc.py
)
