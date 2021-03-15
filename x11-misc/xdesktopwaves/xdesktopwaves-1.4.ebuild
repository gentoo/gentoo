# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

DESCRIPTION="A cellular automata setting the background of your X Windows desktop under water"
HOMEPAGE="http://xdesktopwaves.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
RDEPEND="
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
KEYWORDS="amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-gentoo.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake
	emake -C xdwapi
}

src_install() {
	dobin xdesktopwaves xdwapi/xdwapidemo
	doman xdesktopwaves.1
	insinto /usr/share/pixmaps
	doins xdesktopwaves.xpm
	make_desktop_entry xdesktopwaves
	einstalldocs
}
