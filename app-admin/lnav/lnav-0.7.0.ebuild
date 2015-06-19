# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lnav/lnav-0.7.0.ebuild,v 1.2 2015/06/07 07:18:21 jlec Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="http://lnav.org"
SRC_URI="https://github.com/tstack/lnav/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/libpcre[cxx]
	sys-libs/ncurses[unicode?]
	sys-libs/readline:0
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-static \
		$(use_with unicode ncursesw)
}

src_compile() {
	emake AR="$(tc-getAR)"
}
