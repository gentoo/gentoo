# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Watt's Up Monitoring Daemon"
HOMEPAGE="https://dev.gentoo.org/~robbat2/wattsup-daemon/"
SRC_URI="https://dev.gentoo.org/~robbat2/wattsup-daemon/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"
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
