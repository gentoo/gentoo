# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 toolchain-funcs

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/davatorium/rofi"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test windowmode"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	gnome-base/librsvg:2
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
		$(use_enable test check) \
		$(use_enable windowmode)
}
