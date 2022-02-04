# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake git-r3

DESCRIPTION="Free Lemmings clone"
HOMEPAGE="https://pingus.gitlab.io/"
EGIT_REPO_URI="https://gitlab.com/pingus/pingus.git"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-libs/jsoncpp:=
	dev-libs/libfmt:=
	dev-libs/libsigc++:2
	media-libs/libmodplug
	media-libs/libpng:=
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/opusfile
	media-libs/sdl2-image[jpeg,png]
	media-sound/mpg123
	virtual/opengl"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	media-libs/glm"
