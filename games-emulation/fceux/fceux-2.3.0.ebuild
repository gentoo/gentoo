# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit cmake lua-single xdg

DESCRIPTION="Portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="https://fceux.com/"
SRC_URI="mirror://sourceforge/fceultra/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5[-gles2-only]
	dev-qt/qtwidgets:5
	media-libs/libglvnd
	media-libs/libsdl2[joystick,sound,threads,video]
	sys-libs/zlib:=[minizip]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.2-warnings.patch
)
DOCS=( README TODO-SDL changelog.txt documentation/. readme.md )

src_prepare() {
	cmake_src_prepare

	# remove hardcoded paths and deprecated options from .desktop
	sed -e '/^Exec=/s:=.*/:=:' \
		-e '/^Icon=/s:=.*:=fceux1:' \
		-e '/^OnlyShowIn=/d' \
		-i fceux.desktop || die

	# avoid QA notice if no git, returns empty strings either way
	sed -i '/^GIT_/s:=.*:=:' scripts/genGitHdr.sh || die
}

src_install() {
	cmake_src_install

	# remove unused/duplicate files
	rm "${ED}"/usr/share/fceux/{lua5{1,.1}.dll,{fceux,taseditor}.chm} \
		"${ED}"/usr/share/doc/${PF}/fceux{,-net-server}.6 \
		"${ED}"/usr/share/man/man6/fceux-net-server.6 || die
}
