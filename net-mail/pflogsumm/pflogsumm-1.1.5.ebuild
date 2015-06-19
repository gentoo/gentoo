# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pflogsumm/pflogsumm-1.1.5.ebuild,v 1.4 2013/05/07 13:56:02 ago Exp $

DESCRIPTION="Pflogsumm is a log analyzer for Postfix logs"
HOMEPAGE="http://jimsun.linxnet.com/postfix_contrib.html"
SRC_URI="http://jimsun.linxnet.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	dev-perl/Date-Calc"

src_install() {
	dodoc README ToDo ChangeLog pflogsumm-faq.txt
	doman pflogsumm.1
	dobin pflogsumm.pl
}
