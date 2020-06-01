# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1 eutils

DESCRIPTION="Universal Radio Hacker: investigate wireless protocols like a boss"
HOMEPAGE="https://github.com/jopohl/urh"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jopohl/urh.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/jopohl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="bladerf hackrf plutosdr rtlsdr uhd"

DEPEND="${PYTHON_DEPS}
		net-wireless/gnuradio[zeromq]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
		bladerf? ( net-wireless/bladerf:= )
		hackrf? ( net-libs/libhackrf:= )
		plutosdr? ( net-libs/libiio:= )
		rtlsdr? ( net-wireless/rtl-sdr:= )
		uhd?    ( net-wireless/uhd:= )"
RDEPEND="${DEPEND}
		dev-python/PyQt5[${PYTHON_USEDEP},testlib]
		net-wireless/gr-osmosdr"

python_configure_all() {
	mydistutilsargs=(
			$(use_with bladerf)
			$(use_with hackrf)
			$(use_with plutosdr)
			$(use_with rtlsdr)
			$(use_with uhd usrp)
			--without-airspy
			--without-limesdr
			)
}
