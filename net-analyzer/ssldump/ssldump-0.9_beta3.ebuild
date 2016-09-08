# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools eutils toolchain-funcs

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="An SSLv3/TLS network protocol analyzer"
HOMEPAGE="http://ssldump.sourceforge.net/"
SRC_URI="
	http://downloads.sourceforge.net/project/${PN}/${PN}/${MY_PV}/${MY_P}.tar.gz
"

LICENSE="openssl"
SLOT="0"
KEYWORDS="amd64 ~arm ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ssl"

RDEPEND="
	net-libs/libpcap
	ssl? ( >=dev-libs/openssl-1 )
"
DEPEND="
	${RDEPEND}
"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-libpcap-header.patch
	"${FILESDIR}"/${PN}-0.9-configure-dylib.patch
	"${FILESDIR}"/${PN}-0.9-openssl-0.9.8.compile-fix.patch
	"${FILESDIR}"/${PN}-0.9-DLT_LINUX_SLL.patch
	"${FILESDIR}"/${PN}-0.9-prefix-fix.patch
	"${FILESDIR}"/${PN}-0.9-declaration.patch
	"${FILESDIR}"/${PN}-0.9-includes.patch
)

src_prepare() {
	default

	eapply_user

	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		--with-pcap-inc="${EPREFIX}/usr/include" \
		--with-pcap-lib="${EPREFIX}/usr/$(get_libdir)" \
		$(usex ssl --with-openssl-inc="${EPREFIX}/usr/include" '--without-openssl') \
		$(usex ssl --with-openssl-lib="${EPREFIX}/usr/$(get_libdir)" '--without-openssl')
}

src_install() {
	dosbin ssldump
	doman ssldump.1
	dodoc ChangeLog CREDITS README
}
