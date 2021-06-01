# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

MY_COMMIT="e8f619c44a23ebba06be1fb4442483d481477b81"

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="https://desmume.org/"
SRC_URI="https://github.com/TASVideos/desmume/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gdb +gui openal wifi"

RDEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libsoundtouch:=
	net-libs/libpcap
	sys-libs/zlib:=
	virtual/opengl
	x11-libs/agg
	x11-libs/libX11
	gui? ( x11-libs/gtk+:3 )
	openal? ( media-libs/openal )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-fix-gtk-cliopts.patch
)
DOCS=( ${PN}/{AUTHORS,ChangeLog,README,README.LIN,doc/.} )

src_configure() {
	local EMESON_SOURCE="${S}/${PN}/src/frontend/posix"
	local emesonargs=(
		$(meson_use gdb gdb-stub)
		$(meson_use gui frontend-gtk)
		$(meson_use openal)
		$(meson_use wifi)
	)
	meson_src_configure
}
