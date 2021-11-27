# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
HOMEPAGE="https://framagit.org/medoc92/npupnp"
SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/expat
	net-libs/libmicrohttpd
	net-misc/curl
"

src_prepare() {
	default
	./autogen.sh || die
}

src_configure() {
	econf \
		--enable-client \
		--enable-debug \
		--enable-device \
		--enable-gena \
		--enable-ipv6 \
		--enable-optssdp \
		--enable-reuseaddr \
		--enable-soap \
		--enable-ssdp \
		--enable-tools \
		--enable-webserver
}
