# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/mean00/avidemux2.git"
	EGIT_CHECKOUT_DIR=${WORKDIR}
	inherit git-r3
else
	MY_PN="${PN/-core/}"
	MY_P="${MY_PN}_${PV}"
	SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="Core libraries for simple video cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
SLOT="2.7"
IUSE="debug nls nvenc sdl system-ffmpeg vaapi vdpau xv"

# Trying to use virtual; ffmpeg misses aac,cpudetection USE flags now though, are they needed?
COMMON_DEPEND="
	dev-db/sqlite:3
	nvenc? ( media-video/nvidia_video_sdk )
	sdl? ( media-libs/libsdl:0 )
	system-ffmpeg? ( >=virtual/ffmpeg-9:0[mp3,theora] )
	vaapi? ( x11-libs/libva:0= )
	vdpau? ( x11-libs/libvdpau:0 )
	xv? ( x11-libs/libXv:0 )
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/avidemux-core-${PV}
	!<media-video/avidemux-${PV}
	nls? ( virtual/libintl:0 )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	!system-ffmpeg? ( dev-lang/yasm[nls=] )
"

S="${WORKDIR}/${MY_P}"
CMAKE_USE_DIR="${S}/${PN/-/_}"

src_prepare() {
	cmake-utils_src_prepare

	if use system-ffmpeg ; then
		# Preparations to support the system ffmpeg. Currently fails because
		# it depends on files the system ffmpeg doesn't install.
		local error="Failed to remove bundled ffmpeg."

		rm -r cmake/admFFmpeg* cmake/ffmpeg* avidemux_core/ffmpeg_package \
			buildCore/ffmpeg || die "${error}"
		sed -e 's/include(admFFmpegUtil)//g' -e '/registerFFmpeg/d' \
			-i avidemux/commonCmakeApplication.cmake || die "${error}"
		sed -e 's/include(admFFmpegBuild)//g' \
			-i avidemux_core/CMakeLists.txt || die "${error}"
	fi
}

src_configure() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	local mycmakeargs=(
		-DAVIDEMUX_SOURCE_DIR='${S}'
		-DGETTEXT="$(usex nls)"
		-DNVENC="$(usex nvenc)"
		-DSDL="$(usex sdl)"
		-DLIBVA="$(usex vaapi)"
		-DVDPAU="$(usex vdpau)"
		-DXVIDEO="$(usex xv)"
	)

	if use debug ; then
		mycmakeargs+=( -DVERBOSE=1 -DADM_DEBUG=1 )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install -j1
}
