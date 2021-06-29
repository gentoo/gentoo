# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Rampart-like game set in space"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BitstreamVera GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	sys-libs/ncurses:=
	sys-libs/readline:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-makefile.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	default

	sed -i "s|GENTOODIR|${EPREFIX}/usr/share/${PN}/|" Makefile || die

	tc-export CXX
	append-cxxflags -std=c++14 #790743
}

src_install() {
	dobin ${PN}
	doman ${PN}.6

	insinto /usr/share/${PN}
	doins *.{ogg,png,ttf}

	einstalldocs

	newicon 1face.png ${PN}.png
	make_desktop_entry ${PN} "Kajaani Kombat"
}
