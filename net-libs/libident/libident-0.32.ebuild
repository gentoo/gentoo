# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libident/libident-0.32.ebuild,v 1.9 2007/08/13 21:39:40 dertobi123 Exp $

DESCRIPTION="A small library to interface to the Ident protocol server"
HOMEPAGE="http://www.simphalempin.com/dev/libident/"
SRC_URI="http://people.via.ecp.fr/~rem/libident/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ppc64 s390 ~sparc x86"
IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
