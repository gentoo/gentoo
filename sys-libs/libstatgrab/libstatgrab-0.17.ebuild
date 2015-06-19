# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libstatgrab/libstatgrab-0.17.ebuild,v 1.6 2014/08/10 20:12:48 slyfox Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="A tool to provide access to statistics about the system on which it's run"
HOMEPAGE="http://www.i-scream.org/libstatgrab/"
SRC_URI="http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT=0
KEYWORDS="amd64 ~arm ~ia64 ppc x86"
IUSE="static-libs"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog PLATFORMS NEWS AUTHORS README )

src_configure() {
	local myeconfargs=(
		--disable-setgid-binaries
		--disable-setuid-binaries
		--disable-deprecated
		--with-ncurses
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}
