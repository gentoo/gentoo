# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="PyJWT"
PYPI_VERIFY_REPO=https://github.com/jpadilla/pyjwt
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="
	https://github.com/jpadilla/pyjwt/
	https://pypi.org/project/PyJWT/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	!dev-python/python-jwt
"
BDEPEND="
	test? (
		>=dev-python/cryptography-3.4.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/test_jwks_client.py::TestPyJWKClient::test_get_jwt_set_sslcontext_default
)

pkg_postinst() {
	optfeature "cryptography" dev-python/cryptography
}
