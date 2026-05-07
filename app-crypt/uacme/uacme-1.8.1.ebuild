# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="A client for the RFC8555 ACMEv2 protocol"
HOMEPAGE="
	https://github.com/ndilieto/uacme
	https://ndilieto.github.io/uacme/uacme.html
	https://ndilieto.github.io/uacme/ualpn.html
"

SRC_URI="
	https://github.com/ndilieto/uacme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc gnutls +openssl +ualpn"

DEPEND="
	net-misc/curl:=
	openssl? ( dev-libs/openssl:= )
	gnutls? ( net-libs/gnutls:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	doc? ( app-text/asciidoc )
"

REQUIRED_USE="
	^^ ( gnutls openssl )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local -a myeconfargs=(
		--with-libcurl
		$(use_enable doc docs)
		$(use_with gnutls)
		$(use_with openssl)
		$(use_with ualpn)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use doc; then
		doman uacme.1
		use ualpn && doman ualpn.1
	fi
}
