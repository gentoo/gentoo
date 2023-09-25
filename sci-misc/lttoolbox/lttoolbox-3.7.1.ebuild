# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Toolbox for lexical processing, morphological analysis and generation of words"
HOMEPAGE="https://www.apertium.org"
SRC_URI="https://github.com/apertium/lttoolbox/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
# PKG_VERSION_ABI in configure.ac
SLOT="0/3"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libxml2:2
	dev-libs/utfcpp
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.7.1-bashism.patch
	"${FILESDIR}"/${PN}-3.7.1-cstdint-include.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --disable-python-bindings
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
