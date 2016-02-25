# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Simple scripts for converting xml to groff or html"
HOMEPAGE="http://sourceforge.net/projects/xmltoman/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/XML-Parser"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README
	doman xmltoman.1 xmlmantohtml.1
}
