# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="QR Code Generator Library in Multiple Languages"
HOMEPAGE="
	https://github.com/EasyCoding/qrcodegen-cmake
	https://github.com/nayuki/QR-Code-generator
"
CMAKE_PV="${PV}-cmake3"
SRC_URI="
	https://github.com/EasyCoding/qrcodegen-cmake/archive/v${CMAKE_PV}.tar.gz -> qr-code-generator-${CMAKE_PV}.tar.gz
	https://github.com/nayuki/QR-Code-generator/archive/v${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/QR-Code-generator-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	# Move the CMake files into the project root.
	mv ../qrcodegen-cmake-${CMAKE_PV}/* . || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
