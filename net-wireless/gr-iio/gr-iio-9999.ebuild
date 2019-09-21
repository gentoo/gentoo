# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="GNU Radio IIO Blocks"
HOMEPAGE="https://github.com/analogdevicesinc/gr-iio"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/gr-iio"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/analogdevicesinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	>=net-wireless/gnuradio-3.7.0:=
	dev-libs/boost:=
	net-libs/libiio:=
	net-libs/libad9361-iio:="

DEPEND="${RDEPEND}
	sys-devel/flex:=
	sys-devel/bison:=
	dev-util/cppunit:=
	dev-lang/swig:0"
