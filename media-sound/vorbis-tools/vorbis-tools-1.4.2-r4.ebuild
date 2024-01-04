# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tools for using the Ogg Vorbis sound file format"
HOMEPAGE="https://xiph.org/vorbis/"
SRC_URI="https://ftp.osuosl.org/pub/xiph/releases/vorbis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="flac kate nls +ogg123 speex"

RDEPEND="
	media-libs/libvorbis
	media-libs/opusfile
	flac? ( media-libs/flac:= )
	kate? ( media-libs/libkate )
	ogg123? (
		media-libs/libao
		net-misc/curl
	)
	speex? ( media-libs/speex )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-r3-docdir.patch
	"${FILESDIR}"/${P}-clang16.patch
	"${FILESDIR}"/${P}-fix-buffer-overflow.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with flac)
		$(use_with kate)
		$(use_enable nls)
		$(use_enable ogg123)
		$(use_with speex)
	)
	econf "${myeconfargs[@]}"
}
