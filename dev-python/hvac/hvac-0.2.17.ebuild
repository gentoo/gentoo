# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python client for HashiCorp Vault"
HOMEPAGE="https://github.com/ianunruh/hvac"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="<dev-python/pyhcl-0.3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
	app-admin/vault
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/semantic_version[${PYTHON_USEDEP}] )"

RESTRICT="test" # need running vault

python_test() {
	nosetests -v || die
}
