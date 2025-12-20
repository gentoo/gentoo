# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN=kImageAnnotator
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool for annotating images"
HOMEPAGE="https://github.com/ksnip/kImageAnnotator"
SRC_URI="https://github.com/ksnip/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtsvg:6
	>=media-libs/kcolorpicker-0.3.1
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? (
		dev-cpp/gtest
		dev-qt/qtbase:6
	)
"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	# Pending upstream fix, bug #965014:
	"${FILESDIR}/${P}-cmake-minreqver-3.16.patch"
	"${FILESDIR}/${PN}-0.7.1-cmake-cleanup.patch"
	"${FILESDIR}/${P}-testfix.patch" # git master, bug #966772
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DBUILD_WITH_QT6=ON
	)
	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	BUILD_DIR="${BUILD_DIR}/tests" cmake_src_test
}
