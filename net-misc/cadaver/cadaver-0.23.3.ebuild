# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cadaver/cadaver-0.23.3.ebuild,v 1.6 2014/08/10 20:43:25 slyfox Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="Command-line WebDAV client"
HOMEPAGE="http://www.webdav.org/cadaver"
SRC_URI="http://www.webdav.org/cadaver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc x86"
IUSE="nls"

RDEPEND=">=net-libs/neon-0.27.0"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.23.2-disable-nls.patch"

	rm -fr lib/{expat,intl,neon}
	sed \
		-e "/NE_REQUIRE_VERSIONS/s/29/& 30/" \
		-e "s:lib/neon/Makefile lib/intl/Makefile ::" \
		-i configure.ac || die "sed configure.ac failed"
	sed -e "s/^\(SUBDIRS.*=\).*/\1/" -i Makefile.in || die "sed Makefile.in failed"
	cp /usr/share/gettext/po/Makefile.in.in po || die "cp failed"

	AT_M4DIR="m4 m4/neon" eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-libs=/usr
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc BUGS ChangeLog FAQ NEWS README THANKS TODO
}
