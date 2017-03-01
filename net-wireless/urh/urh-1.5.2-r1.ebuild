# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
inherit distutils-r1

DESCRIPTION="Universal Radio Hacker: investigate wireless protocols like a boss"
HOMEPAGE="https://github.com/jopohl/urh"
SRC_URI="https://github.com/jopohl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		net-libs/libhackrf
		net-wireless/rtl-sdr"
RDEPEND="${DEPEND}
		dev-python/PyQt5[${PYTHON_USEDEP}]
		net-wireless/gr-osmosdr"
