# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Games Engine for LucasArts' 'DarkForces' and 'Outlaws'"
HOMEPAGE="https://theforceengine.github.io"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/luciusDXL/TheForceEngine.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	# no official release tarball with linux support yet
	SRC_URI="https://github.com/luciusDXL/TheForceEngine/archive/refs/tags/v${P/_/}.tar.xz"
fi

IUSE="+softmidi"

LICENSE="GPL-2"
SLOT="0"

BDEPEND="
	virtual/pkgconfig
"

DEPEND="
	>=media-libs/rtaudio-5.2.0
	>=media-libs/rtmidi-5.0.0
	>=media-libs/libsdl2-2.24.0
	>=media-libs/devil-1.7.0
	>=media-libs/glew-2.0.0
	virtual/opengl
"

RDEPEND="
	${DEPEND}
	softmidi? (
		|| (
			media-sound/fluidsynth
			media-sound/timidity++
		)
	)
	|| (
		gnome-extra/zenity
		kde-apps/kdialog
	)
"
