# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="IRC client intended to be displayed on a text console"
HOMEPAGE="https://rhapsody.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv x86"

DEPEND=">=sys-libs/ncurses-5.0:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-uclibc.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_configure() {
	PKGCONFIG="$(tc-getPKG_CONFIG)" \
		./configure -i /usr/share/rhapsody || die "configure failed"
}

src_compile() {
	emake CC="$(tc-getCC)" LOCALFLAGS="${CFLAGS} -fcommon"
}

src_install() {
	dobin rhapsody

	insinto /usr/share/rhapsody/help
	doins help/*.hlp

	dodoc docs/CHANGELOG
}
