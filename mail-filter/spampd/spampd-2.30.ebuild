# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="spampd is a program to scan messages for possible Unsolicited Commercial E-mail content"
HOMEPAGE="http://www.worlddesign.com/index.cfm/rd/mta/spampd.htm"
SRC_URI="http://www.worlddesign.com/Content/rd/mta/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/net-server
	mail-filter/spamassassin"
DEPEND="${RDEPEND}"

src_install() {
	dosbin spampd
	dodoc changelog.txt spampd-rh-rc-script
	dohtml spampd.html
	newinitd "${FILESDIR}"/init spampd
	newconfd "${FILESDIR}"/conf spampd
}
