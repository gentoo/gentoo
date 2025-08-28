# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="48k ZX Spectrum Emulator"
HOMEPAGE="http://kempelen.iit.bme.hu/~mszeredi/spectemu/spectemu.html"
SRC_URI="http://www.inf.bme.hu/~mszeredi/spectemu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="readline"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86vm
	readline? ( sys-libs/readline:= )
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${P}-automagic.patch
	"${FILESDIR}"/${P}-r2-build.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-svga=no
		--with-x=yes
		$(use_with readline)
	)

	econf "${myconf[@]}"
}

src_compile() {
	default
	emake tapeout
}

src_install() {
	emake install_root="${ED}" install
	dobin tapeout
}
