# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Displays various tables of DNS traffic on your network"
HOMEPAGE="http://dnstop.measurement-factory.com/"
SRC_URI="http://dnstop.measurement-factory.com/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0
	net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}"-pkg-config.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-ipv6
}

src_install() {
	dobin dnstop
	doman dnstop.8
	dodoc CHANGES
}
