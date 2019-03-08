# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Information, extraction or creation for OGG media streams"
HOMEPAGE="https://www.bunkus.org/videotools/ogmtools/"
SRC_URI="https://www.bunkus.org/videotools/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="dvd"

RDEPEND="dvd? ( media-libs/libdvdread )
	media-sound/vorbis-tools"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-comments.patch"
	"${FILESDIR}/${P}-endian-fix.patch"
	"${FILESDIR}/${P}-vorbis_verbosity.patch"
	"${FILESDIR}/${P}-summary_length.patch"
)

src_configure() {
	econf \
		$(use_with dvd dvdread)
}

src_install() {
	dobin ogmmerge ogmdemux ogminfo ogmsplit ogmcat

	use dvd && dobin dvdxchap

	einstalldocs
	doman *.1
}
