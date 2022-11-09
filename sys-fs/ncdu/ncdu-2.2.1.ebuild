# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu/"
SRC_URI="
	https://dev.yorhel.nl/download/${P}.tar.gz
	https://codeberg.org/BratishkaErik/distfiles/media/branch/master/${P}-upstream-zig-0.10-updates-r1.patch
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${DISTDIR}/${P}-upstream-zig-0.10-updates-r1.patch"
)

DEPEND="sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}"
BDEPEND="
	|| ( ~dev-lang/zig-0.10.0 ~dev-lang/zig-bin-0.10.0 )
	virtual/pkgconfig
"

# see https://github.com/ziglang/zig/issues/3382
# For now, Zig doesn't support CFLAGS/LDFLAGS/etc.
QA_FLAGS_IGNORED="usr/bin/ncdu"

src_test() {
	zig build test || die "Tests failed"
}

src_install() {
	emake PREFIX="${ED}"/usr install

	dodoc README.md ChangeLog
}
