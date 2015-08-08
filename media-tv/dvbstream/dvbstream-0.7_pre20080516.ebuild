# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

IUSE=""

DESCRIPTION="simple command line tools for DVB cards. Includes a RTP multicast stream server"
HOMEPAGE="http://sourceforge.net/projects/dvbtools"

#SRC_URI="mirror://sourceforge/dvbtools/${P}.tar.gz"
#MY_P=${PN}-snapshot-${PV##*_pre}
MY_P=${PN}-snapshot-20080302
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="dev-lang/perl"
DEPEND="virtual/linuxtv-dvb-headers"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-update.diff"
	epatch "${FILESDIR}/${PN}-0.7_pre20080302-telnet-port-switch.diff"

	cd "${S}"
	sed -i Makefile \
		-e 's:$(CFLAGS):$(CFLAGS) $(CPPFLAGS):' \
		-e '/CFLAGS.*=.*-g -Wall -O2/s:-g -Wall -O2::' \
		-e '/CFLAGS.*=/s:CFLAGS:CPPFLAGS:' \
		-e 's:-I \.\./DVB/include:-I /usr/include:'

	cp TELNET/svdrpsend.pl dvbstream-send.pl
	cp TELNET/README README.telnet

	sed -e 's:\./svdrpsend.pl:dvbstream-send.pl:' \
		-i TELNET/*.sh

	sed -e 's:^DUMPRTP=.*$:DUMPRTP=dumprtp:' \
		-e 's:^TS2ES=.*$:TS2ES=ts2es:' \
		-i *.sh
}

src_install() {
	dobin dvbstream dumprtp rtpfeed ts_filter dvbstream-send.pl

	dodoc README*

	insinto /usr/share/doc/${PF}/tune
	doins TELNET/*.sh

	insinto /usr/share/doc/${PF}/multicast
	doins *.sh
}
