# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils

DESCRIPTION="interface to the new Yahoo! Messenger protocol"
HOMEPAGE="http://libyahoo2.sourceforge.net/"
SRC_URI="mirror://sourceforge/libyahoo2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs ssl"

RDEPEND="dev-libs/glib:2
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	sed -i -e 's:-ansi -pedantic::' configure.ac || die #240912
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable ssl sample-client)
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use ssl; then
		dobin src/.libs/{autoresponder,yahoo} || die
	fi

	dodoc AUTHORS ChangeLog doc/*.txt NEWS README TODO

	find "${D}" -name '*.la' -exec rm -f '{}' +
}
