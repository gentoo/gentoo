# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
inherit gnome2-utils waf-utils python-any-r1

DESCRIPTION="Modular patch bay for JACK-based audio and MIDI systems"
HOMEPAGE="http://drobilla.net/software/patchage"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug jack-dbus session"

RDEPEND=">=dev-cpp/glibmm-2.14:2
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/libglademm-2.6.0:2.4
	dev-cpp/libgnomecanvasmm:2.6
	>=media-libs/ganv-1.4.0
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	jack-dbus? ( dev-libs/dbus-glib
		sys-apps/dbus )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/boost
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_configure() {
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use alsa || echo "--no-alsa") \
		$(use jack-dbus && echo "--jack-dbus") \
		$(use session && echo "--jack-session-manage")
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
