# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system"
HOMEPAGE="https://github.com/linuxaudio/a2jmidid"
SRC_URI="https://github.com/linuxaudio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	media-libs/alsa-lib
	virtual/jack
	dbus? ( sys-apps/dbus )
"
RDEPEND="${CDEPEND}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst internals.txt )

src_configure() {
	local emasonargs=(
		-Ddisable-dbus=$(usex dbus false true)
	)

	meson_src_configure
}
