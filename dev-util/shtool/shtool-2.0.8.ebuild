# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shtool/shtool-2.0.8.ebuild,v 1.2 2012/02/12 14:57:08 armin76 Exp $

DESCRIPTION="A compilation of small but very stable and portable shell scripts into a single shell tool"
HOMEPAGE="http://www.gnu.org/software/shtool/shtool.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
#SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.6"

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README THANKS VERSION NEWS RATIONAL
}
