# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Modular, multithreaded web application server extensible with C++"
HOMEPAGE="http://www.tntnet.org/"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="gnutls libressl server ssl examples"

RDEPEND="
	>=dev-libs/cxxtools-2.2.1
	sys-libs/zlib[minizip]
	ssl? (
		gnutls? (
			net-libs/gnutls:0=
			dev-libs/libgcrypt:0
		)
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/zip
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.0-zlib-minizip.patch )

src_prepare() {
	# Both fixed in the next release
	default
	rm framework/common/{ioapi,unzip}.[ch] || die

	# bug 426262
	mv configure.{in,ac} || die

	# bug 423697
	sed -e "s:unzip.h:minizip/unzip.h:" -i framework/defcomp/unzipcomp.cpp || die

	eautoreconf

	sed -i -e 's:@localstatedir@:/var:' etc/tntnet/tntnet.xml.in || die
}

src_configure() {
	# default enabled, will not compile without sdk
	local myconf=( --with-sdk )

	# Prefer gnutls over SSL
	if use gnutls; then
		einfo "Using gnutls for ssl support."
		myconf+=( --with-ssl=gnutls )
	elif use ssl; then
		einfo "Using openssl for ssl support."
		myconf+=( --with-ssl=openssl )
	else
		myconf+=( --with-ssl=no )
	fi

	econf \
		--disable-static \
		$(use_with server) \
		"${myconf[@]}"
}

src_install() {
	default
	dodoc doc/tntnet.pdf

	if use examples; then
		emake -C sdk/demos maintainer-clean
		rm -r sdk/demos/{Makefile*,*/Makefile*,*/*.{la,lo},*/.libs} || die

		docinto examples
		dodoc -r sdk/demos/.
	fi

	if use server; then
		rm -f "${ED}"/etc/init.d/tntnet || die
		newinitd "${FILESDIR}"/tntnet.initd tntnet
	fi

	# bug 737184
	find "${ED}" -name '*.la' -delete || die
}
