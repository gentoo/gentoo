# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Watt's Up Monitoring Daemon"
HOMEPAGE="http://dev.gentoo.org/~robbat2/wattsup-daemon/"
SRC_URI="http://dev.gentoo.org/~robbat2/wattsup-daemon/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND="dev-perl/Device-SerialPort
		dev-perl/Time-TAI64
		virtual/perl-Time-HiRes"
RDEPEND="${DEPEND}"

mydoc="AUTHORS doc/wattsup_spec_v442.txt"
#myconf="INSTALLSCRIPT=/usr/sbin/"

src_install() {
	perl-module_src_install
	newinitd gentoo/wattsup-daemon.initd wattsup-daemon
	newconfd gentoo/wattsup-daemon.confd wattsup-daemon
}
