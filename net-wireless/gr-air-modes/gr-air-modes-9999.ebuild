# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bistromath/gr-air-modes.git"
	EGIT_BRANCH="master"
else
	KEYWORDS=""
fi
inherit cmake-utils python-single-r1

DESCRIPTION="This module implements a complete Mode S and ADS-B receiver for Gnuradio"
HOMEPAGE="https://www.cgran.org/wiki/gr-air-modes"

LICENSE="GPL-3"
SLOT="0"
IUSE="fgfs rtlsdr uhd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=net-wireless/gnuradio-3.7.0:=
	net-wireless/gr-osmosdr
	$(python_gen_cond_dep '
		dev-python/pyzmq[${PYTHON_MULTI_USEDEP}]
		fgfs? (
			games-simulation/flightgear
			|| (
				sci-libs/scipy-python2[${PYTHON_MULTI_USEDEP}]
				sci-libs/scipy[${PYTHON_MULTI_USEDEP}]
			)
		)
	')
	rtlsdr? ( net-wireless/rtl-sdr )
	uhd? ( >=net-wireless/uhd-3.4.0 )
"
RDEPEND="${DEPEND}"

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"/usr/bin
}
