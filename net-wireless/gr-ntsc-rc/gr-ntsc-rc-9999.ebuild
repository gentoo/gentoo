# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="NTSC receiver and transmitter for 5 GHz drones"
HOMEPAGE="https://github.com/lscardoso/gr-ntsc-rc"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/lscardoso/gr-ntsc-rc.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/lscardoso/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	>=net-wireless/gnuradio-3.7.0:="

DEPEND="${RDEPEND}
	dev-libs/boost:=
	!net-wireless/gr-ntsc"

src_install() {
	cmake-utils_src_install
	dodir /usr/share/doc/${PF}
	mv "${ED}"/usr/share/doc/gr-NTSC/* "${ED}/usr/share/doc/${PF}"
	rm -rf "${ED}"/usr/share/doc/gr-NTSC
}
