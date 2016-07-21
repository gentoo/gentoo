# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="QR Code generator on top of PIL"
HOMEPAGE="https://pypi.python.org/pypi/qrcode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

# optional deps:
# - pillow and lxml for svg backend, set as hard deps
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )"

PATCHES=(
	"${FILESDIR}"/${P}-unicode.patch
)

python_test() {
	"${PYTHON}" -m unittest discover > /dev/tty | less || die "Testing failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install
	doman doc/qr.1
}
