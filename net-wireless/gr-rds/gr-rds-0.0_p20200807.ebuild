# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bastibl/${PN}"
	EGIT_BRANCH="maint-3.8"
else
	KEYWORDS="~amd64 ~x86"
	COMMIT="ffbe3ea302c32a621f14329b7fcc09e868305e78"
	SRC_URI="https://github.com/bastibl/gr-rds/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi
inherit cmake python-single-r1

DESCRIPTION="GNU Radio FM RDS Receiver"
HOMEPAGE="https://github.com/bastibl/gr-rds"

LICENSE="GPL-3"
SLOT="0/${PV}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/boost:=[${PYTHON_MULTI_USEDEP}]
	')
	=net-wireless/gnuradio-3.8*:0=[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig:0
"
#cppunit is listed in cmake, but only needed for tests and there are no tests
#	dev-util/cppunit"

src_prepare() {
	cmake_src_prepare
	#although cppunit is not used, it fails if it isn't there, fix it
	sed -i 's#FATAL_ERROR "CppUnit#MESSAGE "CppUnit#' CMakeLists.txt || die
	sed -i '/${CPPUNIT_INCLUDE_DIRS}/d' CMakeLists.txt || die
	sed -i '/${CPPUNIT_LIBRARY_DIRS}/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( -DPYTHON_EXECUTABLE="${PYTHON}" )
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
