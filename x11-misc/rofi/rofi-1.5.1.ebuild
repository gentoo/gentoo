# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/DaveDavenport/rofi/"
SRC_URI="${HOMEPAGE}/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test windowmode"

RDEPEND="
	dev-libs/glib:2
	media-libs/freetype
	x11-libs/cairo[xcb]
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libxcb
	x11-libs/libxkbcommon[X]
	x11-libs/pango[X]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xineramaproto
	x11-proto/xproto
	test? ( >=dev-libs/check-0.11 )
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.15.12-Werror.patch
	"${FILESDIR}"/${PN}-1.5.0-gtk-settings-test.patch
)

src_prepare() {
	if use test; then
		sed -i -e 's|"/tmp/rofi-test.pid"|"'"$T"'/rofi-test.pid"|g' test/helper-pidfile.c || die
	fi

	default

	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		$(use_enable test check) \
		$(use_enable windowmode)
}
