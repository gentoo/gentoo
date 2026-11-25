# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Toolbox for lexical processing, morphological analysis and generation of words"
HOMEPAGE="https://www.apertium.org"
SRC_URI="https://github.com/apertium/lttoolbox/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
# PKG_VERSION_ABI in configure.ac
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libxml2:2=
"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakecargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
