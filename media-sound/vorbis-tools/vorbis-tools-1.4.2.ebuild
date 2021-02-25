# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools for using the Ogg Vorbis sound file format"
HOMEPAGE="https://xiph.org/vorbis/"
SRC_URI="https://ftp.osuosl.org/pub/xiph/releases/vorbis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="flac kate nls +ogg123 speex"

RDEPEND="
	media-libs/libvorbis
	media-libs/opusfile
	flac? ( media-libs/flac )
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

PATCHES=( "${FILESDIR}"/${P}-docdir.patch )

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
