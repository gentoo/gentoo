# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=frob
inherit autotools-utils

DESCRIPTION="A tool to provide access to statistics about the system on which it's run"
HOMEPAGE="http://www.i-scream.org/libstatgrab/"
SRC_URI="http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT=0
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~x86"
IUSE="doc examples static-libs"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog PLATFORMS NEWS AUTHORS README )

PATCHES=( "${FILESDIR}"/${P}-tinfo.patch )

src_configure() {
	local myeconfargs=(
		--disable-setgid-binaries
		--disable-setuid-binaries
		--with-ncurses
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
