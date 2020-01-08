# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="IRC client intended to be displayed on a text console"
HOMEPAGE="http://rhapsody.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.0:0="
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
	emake CC="$(tc-getCC)" LOCALFLAGS="${CFLAGS}"
}

src_install() {
	dobin rhapsody

	insinto /usr/share/rhapsody/help
	doins help/*.hlp

	dodoc docs/CHANGELOG
}
