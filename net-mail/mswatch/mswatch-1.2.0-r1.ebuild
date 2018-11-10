# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info ltprune

DESCRIPTION="A utility to watch mailstores for changes and initiate mailbox syncs"
HOMEPAGE="http://mswatch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/glib-2.6:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

CONFIG_CHECK="~INOTIFY_USER"
ERROR_INOTIFY_USER="${P} requires in-kernel inotify support."

PATCHES=(
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_configure() {
	econf \
		--with-notify=inotify \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
