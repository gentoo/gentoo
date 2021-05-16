# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="A freecell game for X"
HOMEPAGE="http://www2.giganet.net/~nakayama/"
SRC_URI="http://www2.giganet.net/~nakayama/${P}.tgz
	http://www2.giganet.net/~nakayama/MSNumbers.gz
	https://dev.gentoo.org/~dilfridge/distfiles/${P}-gcc6.patch.xz"
S="${WORKDIR}"/${PN}

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	media-fonts/font-misc-misc
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${WORKDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-ar-ranlib.patch
)

src_configure() {
	tc-export AR CXX RANLIB
}

src_install() {
	dobin xfreecell

	insinto /usr/share/${PN}
	doins "${WORKDIR}"/MSNumbers
	dodoc CHANGES README mshuffle.txt
	doman xfreecell.6

	make_desktop_entry xfreecell XFreecell
}

pkg_postinst() {
	einfo "Remember to restart X if this is the first time you've installed media-fonts/font-misc-misc"
}
