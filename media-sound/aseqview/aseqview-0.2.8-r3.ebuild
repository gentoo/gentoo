# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ALSA sequencer event viewer/filter"
HOMEPAGE="https://github.com/tiwai/aseqview"
SRC_URI="https://ftp.suse.com/pub/people/tiwai/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="
	media-libs/alsa-lib
	net-libs/libpcap
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# upstream git master
	"${FILESDIR}"/${P}-fix-eautoreconf.patch
	"${FILESDIR}"/${P}-automake.patch
	"${FILESDIR}"/${P}-configure-quotes.patch
	"${FILESDIR}"/${P}-piano-segfault.patch # bug 844028
	"${FILESDIR}"/${P}-gcc14.patch
	# downstream patch
	"${FILESDIR}"/${P}-mv-configure.ac.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-alsatest --enable-gtk2
}
