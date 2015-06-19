# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jp2a/jp2a-1.0.6-r1.ebuild,v 1.10 2013/08/15 08:12:39 grobian Exp $

EAPI=2

DESCRIPTION="JPEG image to ASCII art converter"
HOMEPAGE="http://csl.sublevel3.org/jp2a/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~sparc x86 ~x64-macos ~x86-macos ~x64-solaris"
IUSE="curl"

RDEPEND="sys-libs/ncurses
	virtual/jpeg
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable curl)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	dohtml man/jp2a.html
}
