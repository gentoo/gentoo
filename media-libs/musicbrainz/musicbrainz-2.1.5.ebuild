# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-2.1.5.ebuild,v 1.13 2012/05/05 08:02:36 jdhore Exp $

inherit libtool eutils

DESCRIPTION="Client library to access metadata of mp3/vorbis/CD media"
HOMEPAGE="http://musicbrainz.org/"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/lib${P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize
	epatch "${FILESDIR}/${P}-gcc43-includes.patch"
}

src_compile() {
	econf --enable-cpp-headers || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO docs/mb_howto.txt
}
