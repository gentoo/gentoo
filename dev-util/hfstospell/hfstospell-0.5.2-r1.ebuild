# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="HFST spell checker library and command line tool"
HOMEPAGE="https://github.com/hfst/hfst-ospell"
SRC_URI="https://github.com/hfst/hfst-ospell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="clang"

DEPEND="app-arch/libarchive
	dev-libs/icu:=
	!clang? (
		dev-cpp/libxmlpp:2.6
		dev-libs/tinyxml2
	)"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/hfst-ospell-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# https://github.com/hfst/hfst-ospell/issues/48
	if tc-is-clang; then
		econf --without-libxmlpp --without-tinyxml2
	elif use clang; then
		econf --without-libxmlpp --without-tinyxml2
	else
		default
	fi
}

src_install() {
	default
	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die
}
