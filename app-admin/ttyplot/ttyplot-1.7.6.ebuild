# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="9"

inherit toolchain-funcs

DESCRIPTION="Realtime plotting utility with data input from stdin"
HOMEPAGE="https://github.com/tenox7/ttyplot"
SRC_URI="https://github.com/tenox7/ttyplot/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aalib"

RDEPEND="sys-libs/ncurses[tinfo]
	aalib? ( media-libs/aalib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake \
		AA=$(usex aalib 1 0) \
		CC="$(tc-getCC)" \
		VERSION="${PV}"
}

src_install() {
	local args=(
		PREFIX=/usr
		MANPREFIX=/usr/share/man
		DESTDIR="${D}"
	)
	emake "${args[@]}" install
}
