# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1 eutils

DESCRIPTION="Universal Radio Hacker: investigate wireless protocols like a boss"
HOMEPAGE="https://github.com/jopohl/urh"
SRC_URI="https://github.com/jopohl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hackrf rtlsdr uhd"

DEPEND="${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		hackrf? ( net-libs/libhackrf:= )
		rtlsdr? ( net-wireless/rtl-sdr:= )
		uhd?    ( net-wireless/uhd:= )"
RDEPEND="${DEPEND}
		dev-python/PyQt5[${PYTHON_USEDEP}]
		net-wireless/gr-osmosdr"

python_configure_all() {
	mydistutilsargs=(
			$(use_with hackrf)
			$(use_with rtlsdr)
			$(use_with uhd usrp)
			--without-airspy
			--without-limesdr
			)
}
