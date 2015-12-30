# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_P="${PN}-2.8"

DESCRIPTION="A cross-platform open source C and C++ SDK for SOAP/XML Web services"
HOMEPAGE="http://gsoap2.sourceforge.net"
SRC_URI="mirror://sourceforge/gsoap2/gsoap_${PV}.zip"

LICENSE="GPL-2 gSOAP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples ipv6 libressl gnutls +ssl"

RDEPEND="
	sys-libs/zlib
	gnutls? ( net-libs/gnutls )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)
"
DEPEND="${RDEPEND}
	app-arch/unzip
	sys-devel/flex
	sys-devel/bison
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fix Pre-ISO headers
	epatch "${FILESDIR}/${PN}-2.7.10-fedora-install_soapcpp2_wsdl2h_aux.patch"

	eautoreconf
}

src_configure() {
	local myconf=()
	use ssl || myconf+=( --disable-ssl )
	use gnutls && myconf+=( --enable-gnutls )
	use ipv6 && myconf+=( --enable-ipv6 )
	econf \
		${myconf[@]} \
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

	dohtml changelog.md

	prune_libtool_files --all

	if use examples; then
		rm -rf gsoap/samples/Makefile* gsoap/samples/*/Makefile* gsoap/samples/*/*.o || die
		insinto /usr/share/doc/${PF}/examples
		doins -r gsoap/samples/*
	fi

	if use doc; then
		dohtml -r gsoap/doc/*
	fi
}
