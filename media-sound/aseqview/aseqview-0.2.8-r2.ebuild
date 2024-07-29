# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ALSA sequencer event viewer/filter"
HOMEPAGE="https://github.com/tiwai/aseqview"
SRC_URI="https://ftp.suse.com/pub/people/tiwai/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="
	media-libs/alsa-lib
	net-libs/libpcap
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	econf --disable-alsatest --disable-gtktest --enable-gtk2
}
