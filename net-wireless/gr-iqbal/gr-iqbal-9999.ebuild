# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="gnuradio I/Q balancing"
HOMEPAGE="http://git.osmocom.org/gr-iqbal/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://git.osmocom.org/gr-iqbal"
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE=""

RDEPEND=">=net-wireless/gnuradio-3.7_rc:0=[${PYTHON_SINGLE_USEDEP}]
	net-libs/libosmo-dsp:=
	dev-libs/boost:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
