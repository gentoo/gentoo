# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Calculator of perceived sound level for Ogg Vorbis files"
HOMEPAGE="http://sjeng.org/vorbisgain.html"
SRC_URI="http://sjeng.org/ftp/vorbis/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/libvorbis-1
	media-libs/libogg"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-fix-errno-and-warnings.patch # bug 200931
}

src_compile() {
	econf --enable-recursive
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc NEWS README *.txt
}
