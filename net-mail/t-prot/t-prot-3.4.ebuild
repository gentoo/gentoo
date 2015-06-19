# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/t-prot/t-prot-3.4.ebuild,v 1.1 2015/04/26 02:13:20 radhermit Exp $

EAPI=5

DESCRIPTION="TOFU protection - display filter for RFC822 messages"
HOMEPAGE="http://www.escape.de/~tolot/mutt/"
SRC_URI="http://www.escape.de/~tolot/mutt/t-prot/downloads/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-lang/perl
	dev-perl/Locale-gettext
	virtual/perl-Getopt-Long"

src_install() {
	dobin t-prot
	doman t-prot.1
	dodoc ChangeLog README TODO
	docinto contrib
	dodoc contrib/{README.examples,{muttrc,mailcap,nailrc}.t-prot*,t-prot.sl*,filter_innd.pl}
}
