# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An SSLv3/TLS network protocol analyzer"
HOMEPAGE="https://github.com/adulau/ssldump/"
SRC_URI="
	https://github.com/adulau/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="openssl"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ssl"

RDEPEND="
	net-libs/libpcap
	ssl? ( >=dev-libs/openssl-1:0= )
"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CC

	econf \
		$(usex ssl --with-openssl-inc="${EPREFIX}/usr/include" '') \
		$(usex ssl --with-openssl-lib="${EPREFIX}/usr/$(get_libdir)" '') \
		$(usex ssl --with-openssl="${EPREFIX}/usr" '--without-openssl') \
		--with-pcap-inc="${EPREFIX}/usr/include" \
		--with-pcap-lib="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	dosbin ssldump
	doman ssldump.1
	dodoc ChangeLog CREDITS README
}
