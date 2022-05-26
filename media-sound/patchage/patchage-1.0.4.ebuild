# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'
inherit waf-utils python-any-r1 xdg

DESCRIPTION="Modular patch bay for JACK-based audio and MIDI systems"
HOMEPAGE="http://drobilla.net/software/patchage"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug jack-dbus"

BDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost
	virtual/pkgconfig
"
RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	media-libs/ganv
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	jack-dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}-fix-compilation.patch"
)

src_configure() {
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use alsa || echo "--no-alsa") \
		$(use jack-dbus && echo "--jack-dbus")
}
