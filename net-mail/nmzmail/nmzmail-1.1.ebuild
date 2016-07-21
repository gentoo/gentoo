# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Fast mail searching for mutt using namazu"
HOMEPAGE="http://www.ecademix.com/JohannesHofmann/nmzmail.html"
SRC_URI="http://www.ecademix.com/JohannesHofmann/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="sys-libs/readline"
RDEPEND="${DEPEND}
	>=app-text/namazu-2"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS ChangeLog || die
}
