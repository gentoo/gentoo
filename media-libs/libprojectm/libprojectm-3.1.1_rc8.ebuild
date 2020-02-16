# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A graphical music visualization plugin similar to milkdrop"
HOMEPAGE="https://github.com/projectM-visualizer/projectm"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/projectM-visualizer/projectm.git"
	inherit git-r3
else
	MY_PV="${PV/_/-}"
	SRC_URI="https://github.com/projectM-visualizer/projectm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
	S=${WORKDIR}/projectm-${MY_PV}/
fi

LICENSE="LGPL-2"
SLOT="0/2"
IUSE="gles2 qt5 sdl"

RDEPEND="gles2? ( media-libs/mesa[gles2] )
	media-libs/glm
	media-libs/mesa[X(+)]
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtopengl:5
		media-sound/pulseaudio
	)
	sdl? ( >=media-libs/libsdl2-2.0.5 )
	sys-libs/zlib"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gles2 gles)
		$(use_enable qt5 qt)
		$(use_enable sdl)
		--enable-emscripten=no
	)
	econf "${myeconfargs[@]}"
}
