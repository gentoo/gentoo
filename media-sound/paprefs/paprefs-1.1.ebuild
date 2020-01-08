# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic meson xdg-utils

DESCRIPTION="PulseAudio Preferences, configuration dialog for PulseAudio"
HOMEPAGE="https://freedesktop.org/software/pulseaudio/paprefs"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="dev-cpp/atkmm
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/glib:2
	>=dev-libs/libsigc++-2.2:2
	>=media-sound/pulseaudio-12.0-r1[glib]
	x11-libs/gtk+:3
	|| (
		x11-themes/tango-icon-theme
		x11-themes/adwaita-icon-theme
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	append-cxxflags -std=c++11 #568590
	local mymesonargs=(
		-Dlynx=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
