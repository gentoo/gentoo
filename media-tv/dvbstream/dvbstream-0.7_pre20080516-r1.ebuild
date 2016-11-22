# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="RTP multicast stream server and other tools for DVB cards"
HOMEPAGE="https://sourceforge.net/projects/dvbtools"
MY_P="${PN}-snapshot-20080302"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="virtual/linuxtv-dvb-headers"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-update.diff"
	"${FILESDIR}/${PN}-0.7_pre20080302-telnet-port-switch.diff"
)

src_prepare() {
	default

	sed -i Makefile \
		-e 's:$(CFLAGS):$(CFLAGS) $(CPPFLAGS):' \
		-e '/CFLAGS.*=.*-g -Wall -O2/s:-g -Wall -O2::' \
		-e '/CFLAGS.*=/s:CFLAGS:CPPFLAGS:' \
		-e 's:-I \.\./DVB/include:-I /usr/include:' \
		-e 's:$(CC):$(CC) $(LDFLAGS):g' \
		|| die 'failed to fix flags in the Makefile'

	sed -e 's:\./svdrpsend.pl:dvbstream-send.pl:' \
		-i TELNET/*.sh \
		|| die 'failed to rename the svdrpsend.pl command in scripts'

	sed -e 's:^DUMPRTP=.*$:DUMPRTP=dumprtp:' \
		-e 's:^TS2ES=.*$:TS2ES=ts2es:' \
		-i *.sh \
		|| die 'failed to set DUMPRTP and TS2ES in scripts'
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin dvbstream dumprtp rtpfeed ts_filter
	newbin TELNET/svdrpsend.pl dvbstream-send.pl

	dodoc README*
	newdoc TELNET/README README.telnet

	insinto "/usr/share/doc/${PF}/tune"
	doins TELNET/*.sh

	insinto "/usr/share/doc/${PF}/multicast"
	doins *.sh
}
