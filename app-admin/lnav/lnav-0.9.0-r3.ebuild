# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="https://github.com/tstack/lnav/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="unicode"

RDEPEND="
	app-arch/bzip2:0=
	>=dev-db/sqlite-3.9.0
	dev-libs/libpcre[cxx]
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:=[unicode(+)?]
	sys-libs/readline:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )
PATCHES=(
	"${FILESDIR}"/${PN}-0.8.4-disable-tests.patch
	# bug 723242
	"${FILESDIR}"/${PN}-0.9.0-bug639332-tinfow.patch
	# bug 713600
	"${FILESDIR}"/${PN}-0.9.0-bug713600_0.patch
	"${FILESDIR}"/${PN}-0.9.0-bug713600_1.patch
	# Fix a segfault when using right arrow
	# bug 792582
	"${FILESDIR}"/${PN}-0.9.0-bug792582.patch
	# Fix a build failure on gcc
	# bug 786456
	"${FILESDIR}"/${PN}-0.9.0-bug786456.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with unicode ncursesw)
}
