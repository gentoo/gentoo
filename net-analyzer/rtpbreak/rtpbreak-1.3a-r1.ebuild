# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch toolchain-funcs

DESCRIPTION="Analyze any RTP session through heuristics over UDP network traffic"
HOMEPAGE="http://xenion.reactive-search.com/?page_id=7"
SRC_URI="http://xenion.antifork.org/rtpbreak/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libnet:1.1
	>=net-libs/libpcap-0.7"
RDEPEND="${DEPEND}"

src_prepare() {
	# Use limits.h PATH_MAX
	epatch "${FILESDIR}"/${P}-limits.patch \
		"${FILESDIR}"/${P}-missing-headers.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin src/rtpbreak
	dodoc CHANGELOG THANKS
	dohtml -r doc
}
