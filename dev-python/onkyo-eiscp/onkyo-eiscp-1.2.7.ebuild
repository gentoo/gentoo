# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Control Onkyo A/V receivers over the network"
HOMEPAGE="https://github.com/miracle2k/onkyo-eiscp https://pypi.org/project/onkyo-eiscp/"
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

PATCHES=( "${FILESDIR}"/${PN}-1.2.4-exclude-tests.patch )
