# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu/"
SRC_URI="https://dev.yorhel.nl/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig
	~dev-lang/zig-0.9.1"

src_test() {
	zig build test || die "Tests failed"
}

src_install() {
	emake PREFIX="${ED}"/usr install

	dodoc README.md ChangeLog
}
