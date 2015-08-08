# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Library interface to IPMI"
HOMEPAGE="http://sourceforge.net/projects/${PN}/"
MY_PN="OpenIPMI"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt snmp"
S="${WORKDIR}/${MY_P}"

RDEPEND="sys-libs/gdbm
	crypt? ( dev-libs/openssl )
	snmp? ( net-analyzer/net-snmp )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	local myconf=""
	myconf="${myconf} `use_with snmp ucdsnmp yes`"
	myconf="${myconf} `use_with crypt openssl yes`"
	# these binaries are for root!
	econf ${myconf} --bindir=/usr/sbin || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README* FAQ ChangeLog TODO lanserv/README.emulator lanserv/atca.emu
}
