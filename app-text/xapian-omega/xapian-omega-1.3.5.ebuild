# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="An application built on Xapian, consisting of indexers and a CGI search frontend"
SRC_URI="http://www.oligarchy.co.uk/xapian/${PV}/xapian-omega-${PV}.tar.xz"
HOMEPAGE="http://www.xapian.org/"
S="${WORKDIR}/xapian-omega-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-libs/xapian:0/1.3.6
	dev-lang/perl
	dev-libs/libpcre
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_install () {
	emake DESTDIR="${D}" install

	#move docs to /usr/share/doc/${PF}.
	mv "${D}/usr/share/doc/xapian-omega" "${D}/usr/share/doc/${PF}" || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
