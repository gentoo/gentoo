# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/bindfs/bindfs-1.12.5.ebuild,v 1.1 2014/06/16 08:35:19 radhermit Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="FUSE filesystem for mounting a directory to another location and altering permissions"
HOMEPAGE="http://bindfs.org/"
SRC_URI="http://bindfs.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=sys-fs/fuse-2.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.10.7-cflags.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}
