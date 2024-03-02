# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

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
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	>=dev-python/cryptography-3.4[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

python_prepare_all() {
	# Do not install doc in non-standard paths
	sed -e "/data_files/d" -i setup.py || die
	distutils-r1_python_prepare_all
}
