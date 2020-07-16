# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils python-single-r1

DESCRIPTION="IEEE 802.15.4 ZigBee Transceiver"
HOMEPAGE="https://github.com/bastibl/gr-ieee802-15-4"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bastibl/gr-ieee802-15-4.git"
	KEYWORDS=""
else
	COMMIT="a3c79af96e18de3eb3a76659e1669a370efccf17"
	SRC_URI="https://github.com/bastibl/gr-ieee802-15-4/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/gr-ieee802-15-4-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"

RDEPEND="=net-wireless/gnuradio-3.8*:0=[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-libs/boost:=[${PYTHON_MULTI_USEDEP}]
	')
	dev-libs/gmp
	sci-libs/volk
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
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DGR_PKG_DOC_DIR="/usr/share/doc/${P}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_optimize "${ED}/$(python_get_sitedir)"
}
