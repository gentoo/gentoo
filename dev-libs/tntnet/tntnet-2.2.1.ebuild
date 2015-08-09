# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Modular, multithreaded webapplicationserver extensible with C++"
HOMEPAGE="http://www.tntnet.org/"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="doc gnutls server ssl examples"

RDEPEND=">=dev-libs/cxxtools-2.2.1
	sys-libs/zlib[minizip]
	ssl? (
		gnutls? (
			>=net-libs/gnutls-1.2.0
			dev-libs/libgcrypt:0
		)
		!gnutls? ( dev-libs/openssl )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/zip"

src_prepare() {
	# Both fixed in the next release
	epatch "${FILESDIR}"/${PN}-2.0-zlib-minizip.patch
	rm framework/common/{ioapi,unzip}.[ch] || die

	# bug 423697
	sed -e "s:unzip.h:minizip/unzip.h:" -i framework/defcomp/unzipcomp.cpp

	eautoreconf

	sed -i -e 's:@localstatedir@:/var:' etc/tntnet/tntnet.xml.in || die
}

src_configure() {
	local myconf=""

	# Prefer gnutls above SSL
	if use gnutls; then
		einfo "Using gnutls for ssl support."
		myconf="${myconf} --with-ssl=gnutls"
	elif use ssl; then
		einfo "Using openssl for ssl support."
		myconf="${myconf} --with-ssl=openssl"
	else
		myconf="${myconf} --with-ssl=no"
	fi

	# default enabled, will not compile without sdk
	myconf="${myconf} --with-sdk"

	econf \
		$(use_with server) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README TODO
	if use doc; then
		dodoc doc/*.pdf || die
	fi

	if use examples; then
		cd "${S}/sdk/demos"
		emake clean
		rm -rf .deps */.deps .libs */.libs
		cd "${S}"

		insinto /usr/share/doc/${PF}/examples
		doins -r sdk/demos/* || die
	fi

	if use server; then
		rm -f "${D}/etc/init.d/tntnet"
		newinitd "${FILESDIR}/tntnet.initd" tntnet
	fi
}
