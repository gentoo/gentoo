# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GENTOO_DEPEND_ON_PERL_SUBSLOT="no"
inherit perl-module

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
