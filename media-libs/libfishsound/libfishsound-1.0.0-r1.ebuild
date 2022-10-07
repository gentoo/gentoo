# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple programming interface to decode and encode audio with vorbis or speex"
HOMEPAGE="https://www.xiph.org/fishsound/"
SRC_URI="https://downloads.xiph.org/releases/libfishsound/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="flac speex"

RDEPEND="
	media-libs/libogg
	media-libs/libvorbis
	flac? ( media-libs/flac:= )
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# bug #395153
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-pc.patch )

src_prepare() {
	default
	sed -i \
		-e 's:doxygen:doxygen-dummy:' \
		configure || die
}

src_configure() {
	local myconf="--disable-static"
	use flac || myconf="${myconf} --disable-flac"
	use speex || myconf="${myconf} --disable-speex"

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" \
		docdir="${D}/usr/share/doc/${PF}" install
	dodoc AUTHORS ChangeLog README
	find "${ED}" -name '*.la' -delete || die
}
