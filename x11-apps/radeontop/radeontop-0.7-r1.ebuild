# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/radeontop/radeontop-0.7-r1.ebuild,v 1.1 2014/07/04 20:43:46 hasufell Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Utility to view Radeon GPU utilization"
HOMEPAGE="https://github.com/clbr/radeontop"
LICENSE="GPL-3"
SRC_URI="https://github.com/clbr/radeontop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses
	x11-libs/libpciaccess
	nls? ( sys-libs/ncurses[unicode] virtual/libintl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	epatch_user

cat > include/version.h << EOF || die
#ifndef VER_H
#define VER_H

#define VERSION "${PV}"

#endif
EOF
	>getver.sh || die
	touch .git || die
}

src_configure() {
	tc-export CC
	export nls=$(usex nls 1 0)
	# Do not add -g or -s to CFLAGS
	export plain=1
}
