# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake" # broken w/ ninja
inherit cmake

DESCRIPTION="Library for parsing, formatting, and validating international phone numbers"
HOMEPAGE="https://github.com/google/libphonenumber"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
CMAKE_USE_DIR="${WORKDIR}"/${P}/cpp

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"

RESTRICT="test !test? ( test )"

DEPEND="
	dev-libs/icu:=
	dev-libs/protobuf:=
	dev-libs/boost:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-cpp/gtest )
"

PATCHES=(
	# it is either this, or disable BUILD_GEOCODER
	# https://github.com/google/libphonenumber/pull/2556
	"${FILESDIR}"/${PN}-8.12.37-cmake.patch
	# see also https://github.com/google/libphonenumber/pull/2459
	# using a stripped-down patch w/ BUILD_TESTING
	"${FILESDIR}"/${PN}-8.12.37-testing.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DBUILD_TESTING=$(usex test)
		-DREGENERATE_METADATA=OFF # avoid JRE dependency
	)
	cmake_src_configure
}
