# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="WhatsApp's handshake implementation using Noise Protocol"
HOMEPAGE="https://github.com/tgalal/consonance"
SRC_URI="https://github.com/tgalal/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

# Tests require an active internet connection
RESTRICT="test"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dissononce[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/python-axolotl-curve25519[${PYTHON_USEDEP}]
	dev-python/transitions[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}

src_install() {
	distutils-r1_src_install

	use examples && dodoc examples/*.py
}
