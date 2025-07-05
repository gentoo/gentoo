# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High-quality QR Code generator library"
HOMEPAGE="https://github.com/nayuki/QR-Code-generator"

MY_PN="QR-Code-generator"
MY_PV="${PV%_p*}"
CMAKE_PV="${MY_PV}-cmake${PV##*_p}"
SRC_URI="https://github.com/nayuki/QR-Code-generator/archive/refs/tags/v${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz
	https://github.com/EasyCoding/qrcodegen-cmake/archive/refs/tags/v${CMAKE_PV}.tar.gz -> qrcodegen-cmake-${CMAKE_PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	ln -s ../qrcodegen-cmake-"${CMAKE_PV}"/{cmake,CMakeLists.txt} . || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
