# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-single-r1

DESCRIPTION="IEEE 802.15.4 ZigBee Transceiver"
HOMEPAGE="https://github.com/bastibl/gr-ieee802-15-4"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bastibl/gr-ieee802-15-4.git"
else
	COMMIT="c5e55146fadffa9288ed6de52c6c3ccc936688af"
	SRC_URI="https://github.com/bastibl/gr-ieee802-15-4/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/gr-ieee802-15-4-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"

RDEPEND="=net-wireless/gnuradio-3.8*:0=[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-libs/boost:=[${PYTHON_USEDEP}]
	')
	dev-libs/gmp
	sci-libs/volk:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-lang/swig:0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	#although cppunit is not used, it fails if it isn't there, fix it
	sed -i 's#FATAL_ERROR "CppUnit#MESSAGE "CppUnit#' CMakeLists.txt
	sed -i '/${CPPUNIT_INCLUDE_DIRS}/d' CMakeLists.txt
	sed -i '/${CPPUNIT_LIBRARY_DIRS}/d' CMakeLists.txt
	sed -i '/GR_PKG_DOC_DIR/d' CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DGR_PKG_DOC_DIR="/usr/share/doc/${P}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
