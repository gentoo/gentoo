# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="MATE Settings Daemon"
LICENSE="GPL-2+ GPL-3+ HPND LGPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="X accessibility debug libnotify policykit pulseaudio rfkill smartcard +sound"

REQUIRED_USE="pulseaudio? ( sound )"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.50:2
	>=gnome-base/dconf-0.13.4
	>=mate-base/libmatekbd-1.17.0
	>=mate-base/mate-desktop-1.25.0
	media-libs/fontconfig:1.0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	>=x11-libs/libxklavier-5.2
	accessibility? ( >=app-accessibility/at-spi2-core-2.36.0 )
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	policykit? (
		>=dev-libs/dbus-glib-0.71
		>=sys-apps/dbus-1.10.0
		>=sys-auth/polkit-0.97
	)
	pulseaudio? (
		>=media-libs/libmatemixer-1.10[pulseaudio]
		>=media-sound/pulseaudio-0.9.15
	)
	smartcard? ( >=dev-libs/nss-3.11.2 )
	sound? (
		>=media-libs/libmatemixer-1.10
		media-libs/libcanberra[gtk3]
	virtual/libintl
	)
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"

src_configure() {
	mate_src_configure \
		$(use_with X x) \
		$(use_with libnotify) \
		$(use_with sound libcanberra) \
		$(use_with sound libmatemixer) \
		$(use_enable debug) \
		$(use_enable policykit polkit) \
		$(use_enable pulseaudio pulse) \
		$(use_enable rfkill) \
		$(use_enable smartcard smartcard-support)
}
