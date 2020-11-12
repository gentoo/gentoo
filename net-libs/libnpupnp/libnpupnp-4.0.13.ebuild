# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
HOMEPAGE="https://framagit.org/medoc92/npupnp"
SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="client debug device gena ipv6 optssdp reuseaddr soap ssdp tools webserver"

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
		$(use_enable client) \
		$(use_enable debug) \
		$(use_enable device) \
		$(use_enable gena) \
		$(use_enable ipv6) \
		$(use_enable optssdp) \
		$(use_enable reuseaddr) \
		$(use_enable soap) \
		$(use_enable ssdp) \
		$(use_enable tools) \
		$(use_enable webserver)
}
