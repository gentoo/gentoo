# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="QtAV"
CAPI_HASH="b43aa93"
inherit cmake qmake-utils

DESCRIPTION="Multimedia playback framework based on Qt + FFmpeg"
HOMEPAGE="https://www.qtav.org"
SRC_URI="https://github.com/wang-bin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~johu/distfiles/${P}-capi.h-${CAPI_HASH}.xz"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="amd64 ~arm64"
IUSE="gui portaudio pulseaudio vaapi"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-video/ffmpeg:=
	gui? ( dev-qt/qtsql:5 )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-installpaths.patch
	"${FILESDIR}"/${P}-ffmpeg4-{1,2}.patch # bugs 660852, 670765
	"${FILESDIR}"/${P}-qt5.14.patch
	"${FILESDIR}"/${P}-qt5.15.patch
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
		-DBUILD_QT5OPENGL=ON # bug 740172
		-DBUILD_PLAYERS=$(usex gui)
		-DHAVE_PORTAUDIO=$(usex portaudio)
		-DHAVE_PULSE=$(usex pulseaudio)
		-DHAVE_VAAPI=$(usex vaapi)
	)

	cmake_src_configure
	pushd tools/install_sdk >/dev/null
	eqmake5
	popd >/dev/null
}

src_install() {
	cmake_src_install
	emake -C tools/install_sdk INSTALL_ROOT="${ED}" install
}
