# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Library to handle SPNEGO and CredSSP authentication"
HOMEPAGE="https://pypi.org/project/pyspnego/ https://github.com/jborean93/pyspnego"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/gssapi[${PYTHON_USEDEP}]
		>=dev-python/krb5-0.3.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# https://github.com/jborean93/pyspnego/issues/33
	'tests/test_auth.py::test_kerberos_auth_keytab[negotiate-False]'
	'tests/test_auth.py::test_kerberos_auth_keytab[negotiate-True]'
	'tests/test_auth.py::test_kerberos_auth_ccache[negotiate-False]'
	'tests/test_auth.py::test_kerberos_auth_env_cache[negotiate-False]'
)

pkg_postinst() {
	optfeature "Kerberos authentication" "dev-python/gssapi >=dev-python/krb5-0.3.0"
	optfeature "YAML output support" "dev-python/ruamel-yaml"
}
