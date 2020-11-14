# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PulseAudio Volume Meter, simple GTK volume meter for PulseAudio"
HOMEPAGE="http://0pointer.de/lennart/projects/pavumeter/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-libs/libsigc++:2
	>=media-sound/pulseaudio-0.9.7[glib]
	x11-themes/tango-icon-theme"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-desktop-QA.patch )

HTML_DOCS=( doc/{README.html,style.css} )

src_configure() {
	econf --disable-lynx
}
