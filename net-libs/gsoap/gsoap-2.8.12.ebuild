# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gsoap/gsoap-2.8.12.ebuild,v 1.3 2013/10/18 11:39:55 polynomial-c Exp $

EAPI=4

inherit autotools eutils

MY_P="${PN}-2.8"

DESCRIPTION="A cross-platform open source C and C++ SDK to ease the development of SOAP/XML Web services"
HOMEPAGE="http://gsoap2.sourceforge.net"
SRC_URI="mirror://sourceforge/gsoap2/gsoap_${PV}.zip"

LICENSE="GPL-2 gSOAP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples ipv6 gnutls +ssl"

DEPEND="app-arch/unzip
	sys-devel/flex
	sys-devel/bison
	sys-libs/zlib
	gnutls? ( net-libs/gnutls )
	ssl? ( dev-libs/openssl )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fix Pre-ISO headers
	epatch "${FILESDIR}/${PN}-2.7.10-fedora-install_soapcpp2_wsdl2h_aux.patch"

	# Fix configure.in for >=automake-1.13
	sed 's@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@' -i configure.in || die

	eautoreconf
}

src_configure() {
	local myconf=
	use ssl || myconf+="--disable-ssl "
	use gnutls && myconf+="--enable-gnutls "
	use ipv6 && myconf+="--enable-ipv6 "
	econf \
		${myconf} \
		$(use_enable debug) \
		$(use_enable examples samples)
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install

	# yes, we also install the license-file since
	# it contains info about how to apply the licenses
	dodoc *.txt

	dohtml changelog.html

	find "${D}"/usr/ -name "*.la" -exec rm {} \;

	if use examples; then
		rm -rf gsoap/samples/Makefile* gsoap/samples/*/Makefile* gsoap/samples/*/*.o
		insinto /usr/share/doc/${PF}/examples
		doins -r gsoap/samples/*
	fi

	if use doc; then
		dohtml -r gsoap/doc/*
	fi
}
