# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python based FIDO 2.0 library"
HOMEPAGE="https://github.com/Yubico/python-fido2"
SRC_URI="https://github.com/Yubico/python-fido2/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyscard[${PYTHON_USEDEP}]
	examples? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pyfakefs-3.4[${PYTHON_USEDEP}]
	)
"

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r "${S}"/examples/.
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
