# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="https://www.gnu.org/software/jwhois/"
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
