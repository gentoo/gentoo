# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake

DESCRIPTION="library for parsing, formatting, and validating international phone numbers"
HOMEPAGE="https://github.com/google/libphonenumber"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm64"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-libs/boost:=
	dev-libs/icu:=
	dev-libs/protobuf:=
"
BDEPEND="dev-cpp/gtest"

RESTRICT="test" # test is broken

CMAKE_USE_DIR="${S}"/cpp

src_prepare() {
	cmake_src_prepare
}
