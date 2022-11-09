# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Library to handle SPNEGO and CredSSP authentication"
HOMEPAGE="
	https://github.com/jborean93/pyspnego/
	https://pypi.org/project/pyspnego/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/gssapi[${PYTHON_USEDEP}]
		>=dev-python/krb5-0.3.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Kerberos authentication" "dev-python/gssapi >=dev-python/krb5-0.3.0"
	optfeature "YAML output support" "dev-python/ruamel-yaml"
}
