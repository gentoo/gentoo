# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="IEEE 802.15.4 ZigBee Transceiver"
HOMEPAGE="https://github.com/bastibl/gr-ieee802-15-4"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bastibl/gr-ieee802-15-4.git"
	KEYWORDS=""
else
	COMMIT="c969b3fd2059472a28dee6f911083dd03d1dd569"
	SRC_URI="https://github.com/bastibl/gr-ieee802-15-4/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/gr-ieee802-15-4-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"

RDEPEND=">=net-wireless/gnuradio-3.7_rc:0=[${PYTHON_USEDEP}]
	dev-libs/boost:=[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-lang/swig:0"
#cppunit is listed in cmake, but only needed for tests and there are no tests
#	dev-util/cppunit"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	#although cppunit is not used, it fails if it isn't there, fix it
	sed -i 's#FATAL_ERROR "CppUnit#MESSAGE "CppUnit#' CMakeLists.txt
	sed -i '/${CPPUNIT_INCLUDE_DIRS}/d' CMakeLists.txt
	sed -i '/${CPPUNIT_LIBRARY_DIRS}/d' CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=( -DPYTHON_EXECUTABLE="${PYTHON}" )
	cmake-utils_src_configure
}
