# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Library to handle SPNEGO and CredSSP authentication"
HOMEPAGE="https://pypi.org/project/pyspnego/ https://github.com/jborean93/pyspnego"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/gssapi[${PYTHON_USEDEP}]
		dev-python/krb5[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Kerberos authentication" "dev-python/gssapi dev-python/krb5"
	optfeature "YAML output support" "dev-python/ruamel-yaml"
}
