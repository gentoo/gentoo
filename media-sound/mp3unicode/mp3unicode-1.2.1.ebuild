# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3unicode/mp3unicode-1.2.1.ebuild,v 1.1 2012/05/07 11:48:56 yngwin Exp $

EAPI=4

DESCRIPTION="Commandline utility to convert ID3 tags in mp3 files between different encodings"
HOMEPAGE="http://mp3unicode.sourceforge.net"
SRC_URI="http://github.com/alonbl/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/taglib-1.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${D}"/usr/share/doc/${PN}
	dodoc AUTHORS ChangeLog README
}
