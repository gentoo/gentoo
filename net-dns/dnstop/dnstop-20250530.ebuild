# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Displays various tables of DNS traffic on your network"
HOMEPAGE="https://github.com/measurement-factory/dnstop"
SRC_COMMIT="e2ba113b3dc8bc32a2f7bde8d6988a4262af9c8d"
SRC_URI="https://github.com/measurement-factory/dnstop/archive/${SRC_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${SRC_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"

RDEPEND="
	sys-libs/ncurses:0
	net-libs/libpcap
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-20140915"-pkg-config.patch
	"${FILESDIR}/${PN}-20140915"-musl-fix.patch
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
