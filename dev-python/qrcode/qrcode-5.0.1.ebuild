# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qrcode/qrcode-5.0.1.ebuild,v 1.1 2014/06/21 22:55:56 floppym Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="QR Code generator on top of PIL"
HOMEPAGE="https://pypi.python.org/pypi/qrcode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# optional deps:
# - dev-python/lxml for svg backend
# - virtual/pil for PIL backend
RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/lxml[${PYTHON_USEDEP}] )"

python_test() {
	"${PYTHON}" -m unittest qrcode.tests || die "Testing failed with ${EPYTHON}"
}
