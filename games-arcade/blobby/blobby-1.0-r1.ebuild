# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

DESCRIPTION="Beach ball game with blobs of goo"
HOMEPAGE="https://sourceforge.net/projects/blobby/"
SRC_URI="mirror://sourceforge/${PN}/${PN}2-linux-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-games/physfs-2[zip]
	media-libs/libsdl2[sound,joystick,opengl,video]
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	app-arch/zip
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-compile.patch
	"${FILESDIR}"/${P}-paths.patch
	"${FILESDIR}"/${P}-install.patch
)

src_install() {
	cmake_src_install

	newicon data/Icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Blobby Volley" /usr/share/pixmaps/${PN}.bmp
}
