# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6}} )
inherit distutils-r1

DESCRIPTION="Python based FIDO 2.0 library"
HOMEPAGE="https://github.com/Yubico/python-fido2"
SRC_URI="https://github.com/Yubico/python-fido2/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
	)
"

python_test() {
	touch "${S}"/test/__init__.py || die
	esetup.py test
}
