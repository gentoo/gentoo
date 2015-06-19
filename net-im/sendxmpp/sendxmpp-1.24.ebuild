# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/sendxmpp/sendxmpp-1.24.ebuild,v 1.1 2015/06/01 11:05:32 mrueg Exp $

EAPI=5

inherit perl-module

DESCRIPTION="A perl-script to send xmpp (jabber), similar to what mail(1) does for mail"
HOMEPAGE="http://sendxmpp.hostname.sk/"
SRC_URI="https://github.com/lhost/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/Net-XMPP
	dev-perl/Authen-SASL
	virtual/perl-Getopt-Long"
