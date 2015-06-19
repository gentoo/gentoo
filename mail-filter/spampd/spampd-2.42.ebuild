# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spampd/spampd-2.42.ebuild,v 1.2 2014/08/10 21:17:16 slyfox Exp $

EAPI=5

DESCRIPTION="spampd is a program to scan messages for possible Unsolicited Commercial E-mail content"
HOMEPAGE="http://www.worlddesign.com/index.cfm/rd/mta/spampd.htm"
SRC_URI="https://github.com/mpaperno/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/net-server
	mail-filter/spamassassin"
DEPEND="${RDEPEND}"

src_install() {
	dosbin spampd.pl
	dodoc changelog.txt misc/spampd-rh-rc-script.sh misc/spampd.service
	dohtml spampd.html
	newinitd "${FILESDIR}"/init-r1 spampd
	newconfd "${FILESDIR}"/conf spampd
}
