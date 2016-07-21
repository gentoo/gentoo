# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A perl script to adjust the clock tick of the hardware clock on the system board"
HOMEPAGE="http://groups.yahoo.com/group/LinkStation_General/"
SRC_URI="http://www.gentoogeek.org/files/${PN}.zip"

LICENSE="all-rights-reserved"	#441922
SLOT="0"
KEYWORDS="ppc"
RESTRICT="mirror bindist"

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/perl
	>=net-misc/ntp-4.2"

S="${WORKDIR}"

src_prepare() {
	sed -i -e 's:/usr/sbin/tickadj:/usr/bin/tickadj:' adjtime.pl || die
}

src_install() {
	dosbin adjtime.pl
}

pkg_postinst() {
	ewarn "There have been issues with running adjtime as an init script"
	ewarn "(the shell environment for perl is dorked up).  The suggested"
	ewarn "method is to use ntp-date rather than ntpd at startup, and"
	ewarn "add the following two lines to local.start instead:"
	ewarn
	ewarn "/usr/bin/perl /usr/sbin/adjtime.pl -v -s ntp_host -i 60"
	ewarn
	ewarn "/etc/init.d/ntpd start"
	ewarn
	ewarn "replacing ntp_host with your preferred ntp server.  Remember,"
	ewarn "since adjtime uses ntp-date, ntpd must be stopped (or not yet"
	ewarn "started) prior to running the adjtime script."
}
