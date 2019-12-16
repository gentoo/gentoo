# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A minimalistic X11 window manager"
HOMEPAGE="https://www.red-bean.com/decklin/aewm/"
SRC_URI="https://www.red-bean.com/decklin/aewm/${P}.tar.bz2"

LICENSE="MIT 9wm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${P}-r1-gentoo.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		MANDIR="${ED}"/usr/share/man/man1 \
		XROOT="/usr" \
		install

	dodoc NEWS README
}
