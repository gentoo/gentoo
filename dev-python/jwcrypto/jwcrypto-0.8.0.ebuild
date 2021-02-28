# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Implements JWK,JWS,JWE specifications using python-cryptography"

HOMEPAGE="https://github.com/latchset/jwcrypto"
SRC_URI="https://github.com/latchset/jwcrypto/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND=">=dev-python/cryptography-2.3[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

python_prepare_all() {
	# Do not install doc in non-standard paths
	sed -i "\|data_files = \[('share/doc/jwcrypto|d" setup.py || die
	distutils-r1_python_prepare_all
}
