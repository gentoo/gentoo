# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit linux-info autotools-utils

DESCRIPTION="A utility to watch mailstores for changes and initiate mailbox syncs"
HOMEPAGE="http://mswatch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/glib-2.6:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~INOTIFY_USER"
ERROR_INOTIFY_USER="${P} requires in-kernel inotify support."

DOCS=( AUTHORS NEWS README THANKS TODO )
PATCHES=( "${FILESDIR}"/${P}-gcc47.patch )

src_configure() {
	local myeconfargs=(
		--with-notify=inotify
	)
	autotools-utils_src_configure
}
