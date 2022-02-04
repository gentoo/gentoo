# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/davatorium/rofi"
EGIT_REPO_URI="https://github.com/davatorium/rofi"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+drun test +windowmode"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
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
	x11-misc/xkeyboard-config
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	test? ( >=dev-libs/check-0.11 )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC

	local myeconfargs=(
		$(use_enable drun)
		$(use_enable test check)
		$(use_enable windowmode)
	)
	econf "${myeconfargs[@]}"
}
