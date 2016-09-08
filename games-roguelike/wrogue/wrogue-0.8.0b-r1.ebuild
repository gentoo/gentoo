# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Gothic science fantasy roguelike game"
HOMEPAGE="https://freecode.com/projects/wrogue"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[video]"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	sed -i \
		-e "/AppData\[0\]/ s:AppData.*:strcpy(AppData, \"/usr/share/${PN}/\");:" \
		src/lib/appdir.c \
		|| die "sed failed"
}

src_compile() {
	local myCPPFLAGS="-std=c99 -Iinclude -Ilib -Iui -Igenerate"
	local myCFLAGS="$(sdl-config --cflags) ${CFLAGS}"
	emake -C src -f linux.mak STRIP_BINARY=NO \
		CFLAGS="${myCPPFLAGS} ${myCFLAGS}" release
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r data
	dodoc changes.txt

	newicon data/ui/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Warp Rogue" /usr/share/pixmaps/${PN}.bmp
}
