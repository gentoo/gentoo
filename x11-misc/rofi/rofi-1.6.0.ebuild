# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/davatorium/rofi"
SRC_URI="https://github.com/davatorium/rofi/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+drun test +windowmode"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	gnome-base/librsvg:2
	media-libs/freetype
	virtual/jpeg
	x11-libs/cairo[X,xcb(+)]
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
	x11-base/xorg-proto
	test? ( >=dev-libs/check-0.11 )
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.15.12-Werror.patch
	"${FILESDIR}"/${PN}-1.5.0-gtk-settings-test.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		$(use_enable drun) \
		$(use_enable test check) \
		$(use_enable windowmode)
}
