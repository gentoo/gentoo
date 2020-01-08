# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="GNOME Flashback window manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/metacity/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+libcanberra vulkan xinerama"
KEYWORDS="~amd64"

# TODO: libgtop could be optional, but no knob
RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=x11-libs/pango-1.2.0[X]
	>=x11-libs/libXcomposite-0.3
	>=gnome-base/gsettings-desktop-schemas-3.3.0
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXdamage
	libcanberra? ( media-libs/libcanberra[gtk3] )
	>=x11-libs/startup-notification-0.7
	x11-libs/libXcursor
	gnome-base/libgtop:2=
	x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libICE
	x11-libs/libSM
	gnome-extra/zenity
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.4
	x11-base/xorg-proto
	virtual/pkgconfig
" # autoconf-archive for eautoreconf

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable libcanberra canberra) \
		$(use_enable xinerama) \
		$(use_enable vulkan)
}
