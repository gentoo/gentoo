# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Information, extraction or creation for OGG media streams"
HOMEPAGE="https://www.bunkus.org/videotools/ogmtools/"
SRC_URI="https://www.bunkus.org/videotools/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="dvd"

RDEPEND="
	media-sound/vorbis-tools
	dvd? ( media-libs/libdvdread )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-comments.patch
	"${FILESDIR}"/${P}-endian-fix.patch
	"${FILESDIR}"/${P}-vorbis_verbosity.patch
	"${FILESDIR}"/${P}-summary_length.patch
	"${FILESDIR}"/${P}-fix-autotools.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_with dvd dvdread)
}

src_install() {
	dobin ogmmerge ogmdemux ogminfo ogmsplit ogmcat

	use dvd && dobin dvdxchap

	einstalldocs
	doman *.1
}
