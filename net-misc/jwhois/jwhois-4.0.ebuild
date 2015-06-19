# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/jwhois/jwhois-4.0.ebuild,v 1.7 2012/06/14 13:27:06 ago Exp $

DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="http://www.gnu.org/software/jwhois/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ~ppc ppc64 s390 sh sparc x86"
IUSE="idn nls"

DEPEND="idn? ( net-dns/libidn )"

src_compile() {
	econf \
		--localstatedir=/var/cache \
		--without-cache \
		$(use_enable nls) \
		$(use_with idn libidn) \
		|| die "econf failed"
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
