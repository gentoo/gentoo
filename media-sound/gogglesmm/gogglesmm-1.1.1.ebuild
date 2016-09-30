# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Fast and light music player"
HOMEPAGE="http://gogglesmm.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus +flac +mad +vorbis +ogg +opus +aac +pulseaudio +opengl nls"

RDEPEND="x11-libs/fox:=
		x11-libs/libSM
		x11-libs/libICE
		dev-db/sqlite
		media-libs/taglib
		dev-libs/expat
		dev-libs/libgcrypt:=
		dbus? ( sys-apps/dbus )
		flac? ( media-libs/flac )
		mad? ( media-libs/libmad )
		vorbis? ( media-libs/libvorbis )
		ogg? ( media-libs/libogg )
		opus? ( media-libs/opus )
		aac? ( media-libs/faad2 )
		pulseaudio? ( media-sound/pulseaudio )
		opengl? ( media-libs/libepoxy virtual/glu )"
DEPEND="dev-util/cmake ${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_DBUS="$(usex dbus)"
		-DWITH_OPENGL="$(usex opengl)"
		-DWITH_NLS="$(usex nls)"
	)
	cmake-utils_src_configure
}
