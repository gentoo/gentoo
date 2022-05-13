# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Implements JWK,JWS,JWE specifications using python-cryptography"
HOMEPAGE="
	https://github.com/latchset/jwcrypto/
	https://pypi.org/project/jwcrypto/
"
SRC_URI="
	https://github.com/latchset/jwcrypto/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/cryptography-2.3[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

python_prepare_all() {
	# Do not install doc in non-standard paths
	sed -i "/data_files/d" setup.py || die
	distutils-r1_python_prepare_all
}
