# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Extracts and records individual MP3 file tracks from shoutcast streams"
HOMEPAGE="https://streamripper.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="vorbis"

RDEPEND="
	media-libs/libmad
	media-libs/faad2
	>=dev-libs/glib-2.16
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fix-autotools.patch
	"${FILESDIR}"/${P}-fix-c99.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--without-included-libmad \
		--without-included-argv \
		$(use_with vorbis ogg)
}

src_install() {
	default
	dodoc parse_rules.txt
}
