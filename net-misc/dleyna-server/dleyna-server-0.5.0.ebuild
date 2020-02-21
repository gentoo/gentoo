# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils ltprune

DESCRIPTION="library for implementing services that allow clients to discover, browse and manipulate DLNA Servers"
HOMEPAGE="https://01.org/dleyna/"
SRC_URI="https://01.org/sites/default/files/downloads/dleyna/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/dleyna-core-0.5
	>=net-libs/gssdp-0.13.2:0/3
	>=net-libs/gupnp-0.20.3
	>=net-libs/gupnp-av-0.11.5
	>=net-libs/libsoup-2.28.2:2.4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Fix build with recent gupnp, bug #597952
	epatch "${FILESDIR}"/${P}-fix-references-to-GUPnPContextManager.patch
	default
}

src_install() {
	default
	prune_libtool_files
}
