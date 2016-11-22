# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:0=[unicode?]
	sys-libs/readline:0=
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_configure() {
	econf \
		--disable-static \
		$(use_with unicode ncursesw)
}

src_compile() {
	emake AR="$(tc-getAR)"
}
