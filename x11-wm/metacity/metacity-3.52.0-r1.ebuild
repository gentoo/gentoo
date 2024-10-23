# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="GNOME Flashback window manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/metacity/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv"
IUSE="+libcanberra vulkan xinerama"

# TODO: libgtop could be optional, but no knob
RDEPEND="
	>=dev-libs/glib-2.67.3:2
	>=x11-libs/gtk+-3.24.6:3[X]
	>=x11-libs/pango-1.2.0
	>=x11-libs/libXcomposite-0.3
	>=x11-libs/libXres-1.2
	>=gnome-base/gsettings-desktop-schemas-3.3.0
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXpresent
	libcanberra? ( || (
		media-libs/libcanberra-gtk3
		media-libs/libcanberra[gtk3(-)]
	) )
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
	x11-base/xorg-proto
"
BDEPEND="
	vulkan? ( dev-util/vulkan-headers )
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
" # autoconf-archive for eautoreconf

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable libcanberra canberra) \
		$(use_enable xinerama) \
		$(use_enable vulkan)
}
