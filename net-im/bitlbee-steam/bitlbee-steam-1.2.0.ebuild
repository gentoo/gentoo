# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils autotools

DESCRIPTION="Steam protocol plugin for BitlBee"
HOMEPAGE="https://github.com/jgeboski/bitlbee-steam"
SRC_URI="https://github.com/jgeboski/bitlbee-steam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgpg-error
	>=net-im/bitlbee-3.2.1[plugins]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-minimal-flags
}

src_install() {
	default
	prune_libtool_files
}
