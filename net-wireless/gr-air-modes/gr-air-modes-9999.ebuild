# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 cmake-utils git-r3

DESCRIPTION="This module implements a complete Mode S and ADS-B receiver for Gnuradio"
HOMEPAGE="https://www.cgran.org/wiki/gr-air-modes"

EGIT_REPO_URI="https://github.com/bistromath/gr-air-modes.git"
EGIT_BRANCH="master"

KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE="rtlsdr fgfs uhd"
DEPEND=">=net-wireless/gnuradio-3.7.0:=
	net-wireless/gr-osmosdr
	dev-python/pyzmq[${PYTHON_USEDEP}]
	fgfs? ( sci-libs/scipy
		games-simulation/flightgear )
	rtlsdr? ( net-wireless/rtl-sdr )
	uhd? ( >=net-wireless/uhd-3.4.0 )
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"usr/bin
}
