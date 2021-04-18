# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High performance C++ OpenPGP library, fully compliant to RFC 4880"
HOMEPAGE="https://www.rnpgp.org/ https://github.com/rnpgp/rnp/"
SRC_URI="https://github.com/rnpgp/rnp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 BSD Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	app-arch/bzip2
	>=dev-libs/botan-2.14.0
	>=dev-libs/json-c-0.11.0
	sys-libs/zlib
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=dev-util/cmake-3.14.0
	doc? ( dev-ruby/asciidoctor )
"

src_configure() {
	local mycmakeargs=(
		-DDOWNLOAD_GTEST=Off
		-DDOWNLOAD_RUBYRNP=Off
		-DBUILD_TESTING=off
	)

	cmake_src_configure
}
