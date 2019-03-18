# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit perl-module

DESCRIPTION="Sweeps up stray ARP queries from a peering LAN"
HOMEPAGE="https://github.com/AMS-IX/arpsponge"
SRC_URI="https://github.com/AMS-IX/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-lang/perl
	dev-perl/IO-String
	dev-perl/NetAddr-IP
	dev-perl/NetPacket
	dev-perl/Net-ARP
	dev-perl/Net-Pcap
	dev-perl/Readonly
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Gnu
	virtual/perl-Data-Dumper
	virtual/perl-File-Path
	virtual/perl-Getopt-Long
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
"

DEPEND="${RDEPEND}
	sys-devel/make
"

src_install() {
	perl_set_version
	insinto ${VENDOR_LIB}/M6
	doins lib/M6/ReadLine.pm

	insinto ${VENDOR_LIB}/M6/ARP
	doins lib/M6/ARP/Base.pm
	doins lib/M6/ARP/Const.pm
	doins lib/M6/ARP/Control.pm
	doins lib/M6/ARP/Event.pm
	doins lib/M6/ARP/Log.pm
	doins lib/M6/ARP/NetPacket.pm
	doins lib/M6/ARP/Queue.pm
	doins lib/M6/ARP/Sponge.pm
	doins lib/M6/ARP/Table.pm
	doins lib/M6/ARP/Util.pm

	insinto ${VENDOR_LIB}/M6/ARP/Control
	doins lib/M6/ARP/Control/Base.pm
	doins lib/M6/ARP/Control/Client.pm
	doins lib/M6/ARP/Control/Server.pm

	newinitd "${FILESDIR}/arpsponge.initd" arpsponge
	newconfd "${FILESDIR}/arpsponge.confd" arpsponge
	dosbin sbin/asctl sbin/arpsponge sbin/aslogtail
	doman man/asctl.8 man/arpsponge.8 man/aslogtail.8
	dodoc doc/command_mapping.txt doc/arpsponge_architecture.txt
}
