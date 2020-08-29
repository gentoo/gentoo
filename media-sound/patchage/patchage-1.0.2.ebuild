# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE='threads(+)'
inherit waf-utils python-any-r1 xdg

DESCRIPTION="Modular patch bay for JACK-based audio and MIDI systems"
HOMEPAGE="http://drobilla.net/software/patchage"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug jack-dbus session"

RDEPEND=">=dev-cpp/glibmm-2.14:2
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/libglademm-2.6.0:2.4
	dev-cpp/libgnomecanvasmm:2.6
	>=media-libs/ganv-1.5.2
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	jack-dbus? ( dev-libs/dbus-glib
		sys-apps/dbus )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/boost
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}-string.patch"
)

src_configure() {
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use alsa || echo "--no-alsa") \
		$(use jack-dbus && echo "--jack-dbus") \
		$(use session && echo "--jack-session-manage")
}
