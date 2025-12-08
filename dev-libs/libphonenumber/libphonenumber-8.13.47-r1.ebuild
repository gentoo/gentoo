# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for parsing, formatting, and validating international phone numbers"
HOMEPAGE="https://github.com/google/libphonenumber"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
CMAKE_USE_DIR="${WORKDIR}"/${P}/cpp

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	dev-cpp/abseil-cpp:=
	dev-libs/boost:=
	dev-libs/icu:=
	dev-libs/protobuf:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-cpp/gtest )
"

PATCHES=(
	# it is either this, or disable BUILD_GEOCODER
	# https://github.com/google/libphonenumber/pull/2556
	"${FILESDIR}"/${PN}-8.13.47-cmake.patch
	# bug #923946
	"${FILESDIR}"/${PN}-8.13.47-protobuf-link-abseil.patch
	# bug #889910
	"${FILESDIR}"/${PN}-8.13.47-werror.patch
	# bug 963681
	"${FILESDIR}"/${PN}-8.13.47-boost-1.89.patch
)

src_prepare() {
	# https://github.com/google/libphonenumber/pull/2860#issuecomment-1402766427
	touch "${CMAKE_USE_DIR}"/src/phonenumbers/test_metadata.h || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DBUILD_TESTING=$(usex test)
		-DREGENERATE_METADATA=OFF # avoid JRE dependency
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/libphonenumber_test || die
}
