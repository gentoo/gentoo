# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfishsound/libfishsound-1.0.0.ebuild,v 1.7 2012/05/23 16:21:03 johu Exp $

EAPI=2
inherit eutils

DESCRIPTION="Simple programming interface for decoding and encoding audio data using vorbis or speex"
HOMEPAGE="http://www.xiph.org/fishsound/"
SRC_URI="http://downloads.xiph.org/releases/libfishsound/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="flac speex"

RDEPEND="media-libs/libvorbis
	media-libs/libogg
	flac? ( media-libs/flac )
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# bug #395153
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pc.patch
	sed -i \
		-e 's:doxygen:doxygen-dummy:' \
		configure || die
}

src_configure() {
	local myconf=""
	use flac || myconf="${myconf} --disable-flac"
	use speex || myconf="${myconf} --disable-speex"

	econf \
		--disable-dependency-tracking \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" \
		docdir="${D}/usr/share/doc/${PF}" install || die
	dodoc AUTHORS ChangeLog README
}
