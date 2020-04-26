# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

DESCRIPTION="Modular, multithreaded web application server extensible with C++"
HOMEPAGE="http://www.tntnet.org/"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="gnutls libressl server ssl examples"

RDEPEND=">=dev-libs/cxxtools-2.2.1
	sys-libs/zlib[minizip]
	ssl? (
		gnutls? (
			>=net-libs/gnutls-1.2.0
			dev-libs/libgcrypt:0
		)
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	app-arch/zip"

src_prepare() {
	# Both fixed in the next release
	eapply "${FILESDIR}"/${PN}-2.0-zlib-minizip.patch
	rm framework/common/{ioapi,unzip}.[ch] || die

	# bug 426262
	if has_version ">sys-devel/autoconf-2.13"; then
		mv configure.in configure.ac
	fi

	# bug 423697
	sed -e "s:unzip.h:minizip/unzip.h:" -i framework/defcomp/unzipcomp.cpp || die

	eautoreconf

	sed -i -e 's:@localstatedir@:/var:' etc/tntnet/tntnet.xml.in || die

	default
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
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog README TODO doc/tntnet.pdf

	if use examples; then
		cd "${S}/sdk/demos"
		emake clean
		rm -rf .deps */.deps .libs */.libs
		cd "${S}"

		docinto examples
		dodoc -r sdk/demos/*
	fi

	if use server; then
		rm -f "${D}/etc/init.d/tntnet"
		newinitd "${FILESDIR}/tntnet.initd" tntnet
	fi
}
