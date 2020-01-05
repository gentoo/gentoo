# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="QtAV"
CAPI_HASH="b43aa93"
inherit cmake

DESCRIPTION="Multimedia playback framework based on Qt + FFmpeg"
HOMEPAGE="https://www.qtav.org"
SRC_URI="https://github.com/wang-bin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~johu/distfiles/${P}-capi.h-${CAPI_HASH}.xz"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="gui libav opengl portaudio pulseaudio vaapi"
REQUIRED_USE="gui? ( opengl )"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	gui? ( dev-qt/qtsql:5 )
	libav? (
		media-video/libav:=
		x11-libs/libX11
	)
	!libav? ( media-video/ffmpeg:= )
	opengl? ( dev-qt/qtopengl:5 )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-ffmpeg4-{1,2}.patch # bugs 660852, 670765
)

src_prepare() {
	cmake_src_prepare
	cp "${WORKDIR}/${P}-capi.h-${CAPI_HASH}" contrib/capi/capi.h \
		|| die "Failed to add missing header"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_PLAYERS=$(usex gui)
		-DBUILD_QT5OPENGL=$(usex opengl)
		-DHAVE_PORTAUDIO=$(usex portaudio)
		-DHAVE_PULSE=$(usex pulseaudio)
		-DHAVE_VAAPI=$(usex vaapi)
	)

	cmake_src_configure
}
