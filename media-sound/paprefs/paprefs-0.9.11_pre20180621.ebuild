# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic xdg

DESCRIPTION="PulseAudio Preferences, configuration dialog for PulseAudio"
HOMEPAGE="https://freedesktop.org/software/pulseaudio/paprefs"
#SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"
SRC_URI="https://dev.gentoo.org/~polynomial-c/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
IUSE="nls"

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/dbus-glib
	>=dev-libs/libsigc++-2.2:2
	>=media-sound/pulseaudio-12.0-r1[glib]
	|| (
		x11-themes/tango-icon-theme
		x11-themes/adwaita-icon-theme
	)"
DEPEND="${RDEPEND}
	nls? (
		sys-devel/gettext
		dev-util/intltool
	)
	virtual/pkgconfig"

src_configure() {
	append-cxxflags -std=c++11 #568590
	local myeconfargs=(
		--disable-lynx
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	docinto html
	dodoc -r doc
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
