# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Utils for the Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="audiofile gcrypt jpeg png zlib"

RDEPEND=">=app-emulation/libspectrum-1.4.4[audiofile?,gcrypt?,zlib?]
	audiofile? ( >=media-libs/audiofile-0.3.6 )
	gcrypt? ( dev-libs/libgcrypt )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/remove-local-prefix.patch
)

src_prepare() {
	default
	eautoreconf
}

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
