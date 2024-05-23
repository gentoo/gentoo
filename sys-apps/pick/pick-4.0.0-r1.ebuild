# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A fuzzy search tool for the command-line"
HOMEPAGE="https://github.com/mptre/pick"
SRC_URI="https://github.com/mptre/pick/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-tinfo.patch"
)

# all these checks are compiled via a homebrew configure script which
# does set -Werror. bug #908573
QA_CONFIG_IMPL_DECL_SKIP+=(
	# "check if _GNU_SOURCE is needed" ???
	wcwidth
	# not available on Linux
	pledge
	# libbsd
	strtonum
)

src_configure() {
	# not autoconf
	tc-export CC
	./configure || die
}

src_install() {
	emake DESTDIR="${ED}" BINDIR=/usr/bin MANDIR=/usr/share/man install
	dodoc CHANGELOG.md
}
