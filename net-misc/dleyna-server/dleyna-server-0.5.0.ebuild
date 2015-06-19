# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dleyna-server/dleyna-server-0.5.0.ebuild,v 1.1 2015/06/09 23:10:02 eva Exp $

EAPI=5

inherit eutils

DESCRIPTION="library for implementing services that allow clients to discover, browse and manipulate DLNA Servers"
HOMEPAGE="https://01.org/dleyna/"
SRC_URI="https://01.org/sites/default/files/downloads/dleyna/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/dleyna-core-0.5
	>=net-libs/gssdp-0.13.2
	>=net-libs/gupnp-0.20.3
	>=net-libs/gupnp-av-0.11.5
	>=net-libs/libsoup-2.28.2:2.4
"
DEPEND="${DEPEND}
	virtual/pkgconfig
"

src_install() {
	default
	prune_libtool_files
}
