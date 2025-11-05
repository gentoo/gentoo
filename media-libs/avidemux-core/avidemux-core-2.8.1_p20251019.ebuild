# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic toolchain-funcs

MY_COMMIT="376c1469eebedcc724dbbcc0d45030f32c9d13f5"

DESCRIPTION="Core libraries for simple video cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="https://github.com/mean00/avidemux2/archive/${MY_COMMIT}.tar.gz -> avidemux-${PV}.tar.gz"
S="${WORKDIR}/avidemux2-${MY_COMMIT}"
CMAKE_USE_DIR="${S}/${PN/-/_}"

# Multiple licenses because of all the bundled stuff.
# See License.txt.
LICENSE="GPL-2 MIT PSF-2 LGPL-2 OFL-1.1"
SLOT="2.7"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls nvenc sdl vaapi vdpau xv"

# Trying to use virtual; ffmpeg misses aac,cpudetection USE flags now though, are they needed?
DEPEND="
	dev-db/sqlite:3
	virtual/zlib
	nvenc? ( amd64? ( media-libs/nv-codec-headers ) )
	sdl? ( media-libs/libsdl )
	vaapi? ( media-libs/libva:= )
	vdpau? ( x11-libs/libvdpau )
	xv? ( x11-libs/libXv )
"
RDEPEND="
	${DEPEND}
	!<media-libs/avidemux-core-${PV}
	!<media-video/avidemux-${PV}
	nls? ( virtual/libintl )
"
BDEPEND="
	dev-lang/yasm[nls=]
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/avidemux-core-2.8.1_p20251019-ffmpeg-flags.patch
)

src_prepare() {
	cmake_src_prepare

	local ffmpeg_args=(
		--cc=$(tc-getCC)
		--cxx=$(tc-getCXX)
		--ar=$(tc-getAR)
		--nm=$(tc-getNM)
		--ranlib=$(tc-getRANLIB)
		"--optflags='${CFLAGS}'"
	)

	sed -i -e "s/@@GENTOO_FFMPEG_FLAGS@@/${ffmpeg_args[*]}/" avidemux_core/cmake/ffmpeg_configure.sh.cmake || die
}

src_configure() {
	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	local mycmakeargs=(
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DLIBVA="$(usex vaapi)"
		-DNVENC="$(usex nvenc)"
		-DVDPAU="$(usex vdpau)"
		-DXVIDEO="$(usex xv)"
	)

	use debug && mycmakeargs+=( -DVERBOSE=1 -DADM_DEBUG=1 )

	cmake_src_configure
}
