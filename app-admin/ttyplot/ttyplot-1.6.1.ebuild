# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Realtime plotting utility with data input from stdin"
HOMEPAGE="https://github.com/tenox7/ttyplot"
SRC_URI="https://github.com/tenox7/ttyplot/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/pkgconfig"
DEPEND="${RDEPEND}
	sys-libs/ncurses[tinfo]"

src_install() {
	local args=(
		PREFIX=/usr
		MANPREFIX=/usr/share/man
		DESTDIR="${D}"
	)
	emake "${args[@]}" install
}
