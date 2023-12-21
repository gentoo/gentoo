# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
LICENSE="FDL-1.1 GPL-2+ LGPL-2+ MIT-with-advertising"
SLOT="0"

IUSE="X debug +introspection startup-notification"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	>=gnome-base/dconf-0.13.4
	x11-libs/cairo
	x11-libs/libX11
	>=x11-libs/libXrandr-1.3
	>=x11-libs/gtk+-3.22:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
	startup-notification? ( >=x11-libs/startup-notification-0.5:0 )
"

RDEPEND="${COMMON_DEPEND}"

BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/iso-codes
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.8
	>=x11-libs/gdk-pixbuf-2.36.5
	virtual/pkgconfig
"

DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"

src_configure() {
	mate_src_configure \
		--enable-mate-about \
		$(use_with X x) \
		$(use_enable debug) \
		$(use_enable introspection) \
		$(use_enable startup-notification)
}
