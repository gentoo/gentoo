# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/xmltoman/xmltoman-0.4.ebuild,v 1.6 2015/01/15 14:22:55 mrueg Exp $

EAPI=5

DESCRIPTION="Simple scripts for converting xml to groff or html"
HOMEPAGE="http://sourceforge.net/projects/xmltoman/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/XML-Parser"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README
	doman xmltoman.1 xmlmantohtml.1
}
