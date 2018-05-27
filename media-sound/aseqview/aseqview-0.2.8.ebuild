# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ALSA sequencer event viewer/filter"
HOMEPAGE="https://www.alsa-project.org/~iwai/alsa.html"
SRC_URI="https://ftp.suse.com/pub/people/tiwai/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=media-libs/alsa-lib-0.9.0
	x11-libs/gtk+:2
	net-libs/libpcap"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --disable-alsatest --disable-gtktest --enable-gtk2
}
