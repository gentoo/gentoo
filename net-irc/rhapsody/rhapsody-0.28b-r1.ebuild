# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="IRC client intended to be displayed on a text console"
HOMEPAGE="https://rhapsody.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/rhapsody/rhapsody/Rhapsody%20IRC%20${PV}/${PN}_${PV}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

DEPEND=">=sys-libs/ncurses-5.0:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-uclibc.patch
	"${FILESDIR}"/${P}-fix_gcc15.patch
)

src_configure() {
	CC="$(tc-getCC)" \
	CCBASEFLAGS="${CFLAGS} -fcommon" \
	CCBASELIBS="${LDFLAGS} $($(tc-getPKG_CONFIG) --libs ncurses)" \
		./configure -c cc || die "configure failed"
}

src_install() {
	dobin rhapsody

	insinto /usr/share/rhapsody/help
	doins help/*.hlp

	dodoc docs/CHANGELOG
}
