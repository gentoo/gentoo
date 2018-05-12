# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utils for the Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audiofile gcrypt jpeg png zlib"

RDEPEND=">=app-emulation/libspectrum-1.4.2[gcrypt?,zlib?]
	audiofile? ( >=media-libs/audiofile-0.3.6 )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_with audiofile)
		$(use_with gcrypt libgcrypt)
		$(use_with jpeg libjpeg)
		$(use_with png libpng)
		$(use_with zlib)
	)
	econf "${myconf[@]}"
}
