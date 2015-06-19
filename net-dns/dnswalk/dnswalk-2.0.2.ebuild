# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnswalk/dnswalk-2.0.2.ebuild,v 1.18 2013/04/08 18:00:48 ulm Exp $

EAPI=4

DESCRIPTION="dnswalk is a DNS database debugger"
HOMEPAGE="http://sourceforge.net/projects/dnswalk/"
SRC_URI="mirror://sourceforge/dnswalk/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND=">=dev-perl/Net-DNS-0.12"

S=${WORKDIR}

src_prepare() {
	sed -i 's:#!/usr/contrib/bin/perl:#!'"${EPREFIX}"'/usr/bin/perl:' dnswalk
}

src_install () {
	dobin dnswalk

	dodoc CHANGES README TODO \
		do-dnswalk makereports sendreports rfc1912.txt dnswalk.errors
	doman dnswalk.1
}
