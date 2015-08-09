# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Listen to your network"
HOMEPAGE="http://falcon.fugal.net/~fugalh/hearnet"
SRC_URI="http://falcon.fugal.net/~fugalh/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-amd64: 0.0.2: No sound sent to jack server
KEYWORDS="-amd64 ~ppc x86"
IUSE=""

RDEPEND="net-libs/libpcap
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} ${PN}.cpp -o \
		${PN} $(pkg-config --libs jack) -lpcap || die "build failed."
}

src_install () {
	dosbin ${PN}
	insinto /usr/share/${PN}
	doins grain.*
	dodoc AUTHORS ChangeLog README TODO
}
