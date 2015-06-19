# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/radeontop/radeontop-9999.ebuild,v 1.2 2014/11/14 02:16:03 dlan Exp $

EAPI=5
inherit eutils toolchain-funcs git-r3

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
LICENSE="GPL-3"
EGIT_REPO_URI="https://github.com/clbr/radeontop.git"

SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	sys-libs/ncurses
	x11-libs/libpciaccess
	x11-libs/libdrm
	nls? ( sys-libs/ncurses[unicode] virtual/libintl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	epatch_user
}

src_configure() {
	tc-export CC
	export nls=$(usex nls 1 0)
	# Do not add -g or -s to CFLAGS
	export plain=1
}
