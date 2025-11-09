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
IUSE="debug nls nvenc vaapi vdpau xv"

DEPEND="
	dev-db/sqlite:3
	virtual/zlib:=
	nvenc? ( media-libs/nv-codec-headers )
	vaapi? (
		media-libs/libva:=[X]
		x11-libs/libX11
	)
	vdpau? (
		x11-libs/libvdpau
		x11-libs/libX11
	)
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
	)
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
		--cxx=$(tc-getCXX)
		--nm=$(tc-getNM)
		--ranlib=$(tc-getRANLIB)
		--pkg-config=$(tc-getPKG_CONFIG)
		# avoid automagic with libdrm, vaapi, vdpau ...
		--disable-autodetect
		"--optflags='${CFLAGS} -std=gnu17'"
	)

	sed -i -e "s#@@GENTOO_FFMPEG_FLAGS@@#${ffmpeg_args[*]}#" avidemux_core/cmake/ffmpeg_configure.sh.cmake || die
}

src_configure() {
	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	local mycmakeargs=(
		-DADM_DEBUG="$(usex debug)"
		-DVERBOSE=ON
		-DGETTEXT="$(usex nls)"
		-DLIBVA="$(usex vaapi)"
		-DNVENC="$(usex nvenc)"
		-DVDPAU="$(usex vdpau)"
		-DXVIDEO="$(usex xv)"
	)

	cmake_src_configure
}
