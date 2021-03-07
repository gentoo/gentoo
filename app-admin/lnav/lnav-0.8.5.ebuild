# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs autotools

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="https://github.com/tstack/lnav/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

RDEPEND="
	app-arch/bzip2:0=
	dev-db/sqlite:3
	dev-libs/libpcre[cxx]
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:0=[unicode?]
	sys-libs/readline:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )
PATCHES=( "${FILESDIR}"/${PN}-0.8.4-disable-tests.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with unicode ncursesw)
}
