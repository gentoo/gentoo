# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/psmon/psmon-1.39-r1.ebuild,v 1.3 2015/04/02 07:26:03 zlogene Exp $

EAPI="5"

inherit perl-app

DESCRIPTION="Monitors process table to slay aggressive, and spawn dead, processes"
HOMEPAGE="http://www.psmon.com/"
SRC_URI="http://www.psmon.com/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.0
	dev-perl/Config-General
	dev-perl/Proc-ProcessTable
	dev-perl/Unix-Syslog
	virtual/perl-Getopt-Long"

src_install() {
	perl-module_src_install
	insinto /etc
	doins etc/psmon.conf
}

pkg_postinst() {
	einfo "NOTICE: Please modify at least the NotifyEmail parameter found in"
	einfo "the /etc/psmon.conf file"
}
