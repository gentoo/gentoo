# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Gothic science fantasy roguelike game"
HOMEPAGE="http://freshmeat.sourceforge.net/projects/wrogue"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libsdl[video]"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-string-allocation.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake -C src -f linux.mak release
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r data
	dodoc changes.txt

	newicon data/ui/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Warp Rogue" /usr/share/pixmaps/${PN}.bmp
}
