# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE2_LA_PUNT="yes"

inherit mate meson

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
else
	KEYWORDS=""
fi

DESCRIPTION="MATE default window manager"
LICENSE="FDL-1.2+ GPL-2+ LGPL-2+ MIT"
SLOT="0/2"

IUSE="startup-notification test xinerama"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.58:2
	>=gnome-base/libgtop-2:2=
	media-libs/libcanberra[gtk3]
	x11-libs/cairo
	>=x11-libs/pango-1.2[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.3
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXpresent
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXres
	>=x11-libs/startup-notification-0.7
	xinerama? ( x11-libs/libXinerama )
"

RDEPEND="${COMMON_DEPEND}
	gnome-extra/zenity
	>=mate-base/mate-desktop-1.20.0
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-base/xorg-proto )
"

src_configure() {
	local emesonargs=(
		-Dcompositor=true
		-Drender=true
		-Dshape=true
		-Dsm=true
		-Dxsync=true
		$(meson_use startup-notification)
		$(meson_use xinerama)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc doc/*.txt
}
