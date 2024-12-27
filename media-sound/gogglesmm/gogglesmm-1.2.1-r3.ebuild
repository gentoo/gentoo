# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Fast and light music player"
HOMEPAGE="https://gogglesmm.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aac +dbus +flac +mad nls +ogg +opengl +opus +pulseaudio +vorbis"

RDEPEND="
	dev-db/sqlite
	dev-libs/expat
	dev-libs/libgcrypt:=
	media-libs/taglib:=
	x11-libs/fox:1.7
	x11-libs/libICE
	x11-libs/libSM
	aac? ( media-libs/faad2 )
	dbus? ( sys-apps/dbus )
	flac? ( media-libs/flac:= )
	mad? ( media-libs/libmad )
	ogg? ( media-libs/libogg )
	opengl? (
		media-libs/libepoxy
		virtual/glu
	)
	opus? ( media-libs/opus )
	pulseaudio? ( media-libs/libpulse )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/"${P}"-use-fox-1.7.67.patch
	"${FILESDIR}"/"${P}"-fix-build-taglib2.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_DBUS="$(usex dbus)"
		-DWITH_NLS="$(usex nls)"
		-DWITH_OPENGL="$(usex opengl)"
		-DWITH_CFOX=OFF
	)
	cmake_src_configure
}
