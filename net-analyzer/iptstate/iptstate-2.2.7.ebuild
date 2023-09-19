# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
HOMEPAGE="https://www.phildev.net/iptstate/ https://github.com/jaymzh/iptstate"
SRC_URI="https://github.com/jaymzh/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"

RDEPEND=">=sys-libs/ncurses-5.7-r7:=
	>=net-libs/libnetfilter_conntrack-0.0.50"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.7-respect-LDFLAGS.patch
	"${FILESDIR}"/${PN}-2.2.7-use-pkg-config.patch
	"${FILESDIR}"/${PN}-2.2.7-respect-CPPFLAGS.patch
)

src_configure() {
	tc-export CXX PKG_CONFIG
}

src_install() {
	emake PREFIX="${D}"/usr install
	dodoc BUGS Changelog CONTRIB README.md WISHLIST
}
