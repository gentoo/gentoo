# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="AXL provides a common C interface to transfer files in an HPC storage hierarchy."
HOMEPAGE="https://github.com/ECP-VeloC/AXL"
SRC_URI="https://github.com/ECP-VeloC/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib
	sys-cluster/KVTree
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-2.8
"

src_prepare() {
	#do not build static library
	sed -i '/axl-static/d' src/CMakeLists.txt || die
	#do not auto install README
	sed -i '/FILES README.md DESTINATION/d' CMakeLists.txt || die
	default
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		#other options available: CRAY_DW INTEL_CPPR IBM_BBAPI
		-DAXL_ASYNC_API=NONE
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc -r doc/.
}
