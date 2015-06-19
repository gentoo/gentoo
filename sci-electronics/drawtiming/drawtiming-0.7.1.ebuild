# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/drawtiming/drawtiming-0.7.1.ebuild,v 1.4 2011/08/07 03:14:22 phajdan.jr Exp $

EAPI=3

inherit eutils

DESCRIPTION="Command line tool for drawing timing diagrams"
HOMEPAGE="http://drawtiming.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND="media-gfx/imagemagick"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
	    "${FILESDIR}"/${P}-ldflags.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README THANKS || die
	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins samples/*.txt || die
	fi
}
