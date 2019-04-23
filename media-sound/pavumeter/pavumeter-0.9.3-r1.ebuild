# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit flag-o-matic

DESCRIPTION="PulseAudio Volume Meter, simple GTK volume meter for PulseAudio"
HOMEPAGE="http://0pointer.de/lennart/projects/pavumeter/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/libsigc++:2
	>=media-sound/pulseaudio-0.9.7[glib]
	x11-themes/tango-icon-theme"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	append-cxxflags -std=c++11 #568592
	econf \
		--disable-lynx
}

src_install() {
	default
	dohtml -r doc
}
