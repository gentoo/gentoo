# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

MY_PN="Parse-Evtx"
DESCRIPTION="Read, decode and dump Windows Vista/2008/7 event log file "
HOMEPAGE="http://computer.forensikblog.de/en/topics/windows/vista_event_log"
SRC_URI="http://computer.forensikblog.de/files/evtx/${MY_PN}-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip
	dev-perl/DateTime
	dev-perl/Digest-CRC
	dev-perl/DateTime
	dev-perl/Carp-Assert
	dev-perl/Data-Hexify"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_postinst() {
	einfo "Consider the following as how-to:"
	einfo "http://rwmj.wordpress.com/2011/04/17/decoding-the-windows-event-log-using-guestfish/"
}
