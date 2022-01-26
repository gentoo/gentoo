# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESMUME_COMMIT="b4080b2cae2f8e2700e318b97e369915e8995796"

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="https://desmume.org/"
SRC_URI="https://github.com/TASVideos/desmume/archive/${DESMUME_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${DESMUME_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gdb +gui openal wifi"

RDEPEND="
	dev-libs/glib:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libsoundtouch:=
	net-libs/libpcap
	sys-libs/zlib:=
	virtual/opengl
	x11-libs/agg
	x11-libs/libX11
	gui? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
	openal? ( media-libs/openal )
	!openal? ( media-libs/alsa-lib )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.11_p20210409-fix-gtk-cliopts.patch
	"${FILESDIR}"/${PN}-0.9.11_p20210409-openal-automagic.patch
)

DOCS=( ${PN}/{AUTHORS,ChangeLog,README,README.LIN,doc/.} )

src_configure() {
	local EMESON_SOURCE=${S}/${PN}/src/frontend/posix
	local emesonargs=(
		$(meson_use gdb gdb-stub)
		$(meson_use gui frontend-gtk)
		$(meson_use openal)
		$(meson_use wifi)
	)
	meson_src_configure
}
