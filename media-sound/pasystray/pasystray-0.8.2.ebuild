# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="PulseAudio system tray"
HOMEPAGE="https://github.com/christophgysin/pasystray"
SRC_URI="https://github.com/christophgysin/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="libnotify zeroconf"

RDEPEND="
	dev-libs/glib
	|| (
		media-libs/libpulse[glib]
		media-sound/pulseaudio-daemon[glib,zeroconf?]
	)
	x11-libs/gtk+:3
	x11-libs/libX11
	zeroconf? ( net-dns/avahi )
	libnotify? ( x11-libs/libnotify )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable libnotify notify) \
		$(use_enable zeroconf avahi)
}
