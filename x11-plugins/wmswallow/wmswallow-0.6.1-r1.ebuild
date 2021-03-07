# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A dock applet to make any application dockable"
HOMEPAGE="https://www.dockapps.net/wmswallow"
SRC_URI="https://www.dockapps.net/download/${PN}.tar.Z -> ${P}.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}"/${P}-format-security.patch )

src_prepare() {
	default

	# the Makefile is a mess, just
	# rely on implicit rules instead
	rm Makefile || die
}

src_configure() {
	tc-export CC
	append-cppflags $($(tc-getPKG_CONFIG) --cflags x11 xext)
	export LDLIBS="$($(tc-getPKG_CONFIG) --libs x11 xext)"
}

src_compile() {
	emake wmswallow
}

src_install() {
	dobin wmswallow
	dodoc CHANGELOG README todo
}
