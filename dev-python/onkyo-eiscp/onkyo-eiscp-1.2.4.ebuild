# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Control Onkyo A/V receivers over the network"
HOMEPAGE="https://github.com/miracle2k/onkyo-eiscp https://pypi.python.org/pypi/onkyo-eiscp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/docopt-0.4.1[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-exclude-tests.patch )
