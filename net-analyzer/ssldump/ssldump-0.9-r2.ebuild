# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils eutils toolchain-funcs

MY_P="${PN}-0.9b3"

DESCRIPTION="An SSLv3/TLS network protocol analyzer"
HOMEPAGE="http://www.rtfm.com/ssldump/"
SRC_URI="${HOMEPAGE}${MY_P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="amd64 ~arm ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ssl"

RDEPEND="net-libs/libpcap
	ssl? ( >=dev-libs/openssl-1 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-libpcap-header.patch \
		"${FILESDIR}"/${P}-configure-dylib.patch \
		"${FILESDIR}"/${P}-openssl-0.9.8.compile-fix.patch \
		"${FILESDIR}"/${P}-DLT_LINUX_SLL.patch \
		"${FILESDIR}"/${P}-prefix-fix.patch \
		"${FILESDIR}"/${P}-declaration.patch \
		"${FILESDIR}"/${P}-includes.patch

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-pcap-inc="${EPREFIX}/usr/include"
		--with-pcap-lib="${EPREFIX}/usr/$(get_libdir)"
	)

	if use ssl; then
		myeconfargs+=(
			--with-openssl-inc="${EPREFIX}/usr/include"
			--with-openssl-lib="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		myeconfargs+=( "--without-openssl" )
	fi

	tc-export CC

	autotools-utils_src_configure
}

src_install() {
	dosbin ssldump
	doman ssldump.1
	dodoc ChangeLog CREDITS README
}
