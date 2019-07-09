# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_5,3_6} )

inherit distutils-r1

DESCRIPTION="The FLExible Network Tester"
HOMEPAGE="https://flent.org/"
SRC_URI="https://github.com/tohojo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+qt5 +plots"

RDEPEND="qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
		plots? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
		net-analyzer/netperf[demo]
		net-misc/iperf
		net-analyzer/fping"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
