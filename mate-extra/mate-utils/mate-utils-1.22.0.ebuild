# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Utilities for the MATE desktop"
LICENSE="GPL-2"
SLOT="0"

IUSE="X applet debug ipv6 test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=gnome-base/libgtop-2.12:2=
	>=media-libs/libcanberra-0.4[gtk3]
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/pango
	applet? ( >=mate-base/mate-panel-1.17.0 )"

DEPEND="${RDEPEND}
	app-text/rarian
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto"

src_prepare() {
	# Make apps visible in all DEs.
	LC_ALL=C find . -iname '*.desktop.in*' -exec \
		sed -e '/OnlyShowIn/d' -i {} + || die

	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--disable-maintainer-flags \
		--enable-zlib \
		--enable-debug=$(usex debug yes minimum) \
		$(use_with X x) \
		$(use_enable applet gdict-applet) \
		$(use_enable ipv6)
}
