# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/tnef/tnef-1.4.9.ebuild,v 1.7 2014/08/25 12:30:51 armin76 Exp $

DESCRIPTION="Decodes MS-TNEF MIME attachments"
SRC_URI="mirror://sourceforge/tnef/${P}.tar.gz"
HOMEPAGE="http://world.std.com/~damned/software.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ppc64 ~sparc x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
	rm -rf "${D}"/usr/man
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO || die
	doman doc/tnef.1 || die
}
