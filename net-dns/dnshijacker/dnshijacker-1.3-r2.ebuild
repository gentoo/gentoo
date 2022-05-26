# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="a libnet/libpcap based packet sniffer and spoofer"
HOMEPAGE="http://pedram.redhive.com/code/dns_hijacker/"
SRC_URI="http://pedram.redhive.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="
	>=net-libs/libnet-1.0.2a-r3:1.0
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dosbin dnshijacker ask_dns answer_dns

	insinto /etc/dnshijacker
	doins ftable

	einstalldocs
}
