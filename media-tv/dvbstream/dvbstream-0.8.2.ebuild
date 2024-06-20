# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="RTP multicast stream server and other tools for DVB cards"
HOMEPAGE="https://www.orcas.net/dvbstream/"
SRC_URI="http://www.orcas.net/dvbstream/${P}.tar.bz2"
S=${WORKDIR}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"
BDEPEND="sys-kernel/linux-headers"

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

	# bug 919183
	sed -e '/#include "ringbuffy.h"/a #include <string.h>' \
		-i mpegtools/ringbuffy.c || die 'failed to fix ringbuffy.c'

	sed -e "s:-lcurses:$( $(tc-getPKG_CONFIG) --libs ncurses ):" \
		-i Makefile || die 'failed to fix ncurses linking in Makefile'

	sed -e 's:^DUMPRTP=.*$:DUMPRTP=dumprtp:' -i *.sh || die 'failed to set DUMPRTP and TS2ES in scripts'
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
