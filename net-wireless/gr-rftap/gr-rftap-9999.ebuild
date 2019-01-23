# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rftap/gr-rftap.git"
else
	KEYWORDS=""
fi
inherit cmake-utils python-single-r1

DESCRIPTION="RFtap Module for GNU Radio"
HOMEPAGE="https://github.com/rftap/gr-rftap"

LICENSE="GPL-3"
SLOT="0/${PV}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=[${PYTHON_USEDEP}]
	>=net-wireless/gnuradio-3.7_rc:0=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig:0
"
#cppunit is listed in cmake, but only needed for tests and there are no tests
#	dev-util/cppunit"

src_prepare() {
	cmake-utils_src_prepare
	#although cppunit is not used, it fails if it isn't there, fix it
	sed -i 's#FATAL_ERROR "CppUnit#MESSAGE "CppUnit#' CMakeLists.txt || die
	sed -i '/${CPPUNIT_INCLUDE_DIRS}/d' CMakeLists.txt || die
	sed -i '/${CPPUNIT_LIBRARY_DIRS}/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( -DPYTHON_EXECUTABLE="${PYTHON}" )
	cmake-utils_src_configure
}
