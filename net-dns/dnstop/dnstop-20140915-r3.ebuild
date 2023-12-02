# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Displays various tables of DNS traffic on your network"
HOMEPAGE="https://github.com/measurement-factory/dnstop"
SRC_URI="http://dns.measurement-factory.com/tools/dnstop/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"

RDEPEND="sys-libs/ncurses:0
	net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}"-pkg-config.patch
	"${FILESDIR}/${P}"-musl-fix.patch
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -D_GNU_SOURCE
	econf --enable-ipv6
}

src_install() {
	dobin dnstop
	doman dnstop.8
	dodoc CHANGES
}
