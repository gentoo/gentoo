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
KEYWORDS="~amd64 ~arm ~x86"
IUSE="unicode"

# system-wide yajl cannot be used, because lnav uses custom-patched version
RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/libpcre[cxx]
	net-misc/curl
	sys-apps/gawk
	sys-libs/ncurses:0=[unicode?]
	sys-libs/readline:0
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# respect AR
	sed -r -e '/^AR *= */d' -i -- src/Makefile.in || die
}

src_configure() {
	local econf_args=(
		--disable-static
		$(use_with unicode ncursesw)
	)
	econf "${econf_args[@]}"
}
