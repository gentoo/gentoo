# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"
inherit cmake-utils eutils flag-o-matic l10n toolchain-funcs

SLOT="2.6"
MY_PN="${PN/-core/}"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Core libraries for a video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="mirror://sourceforge/${MY_PN}/${PV}/${MY_P}.tar.gz"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls sdl system-ffmpeg vdpau xv"

DEPEND="
	!<media-video/avidemux-${PV}:${SLOT}
	dev-db/sqlite
	sdl? ( media-libs/libsdl )
	system-ffmpeg? ( >=media-video/ffmpeg-1.0:0[aac,cpudetection,mp3,theora] )
	xv? ( x11-libs/libXv )
	vdpau? ( x11-libs/libvdpau )
"
RDEPEND="
	nls? ( virtual/libintl:0 )
	$DEPEND
"
DEPEND="
	$DEPEND
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	!system-ffmpeg? ( dev-lang/yasm[nls=] )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	if use system-ffmpeg ; then
		# Preparations to support the system ffmpeg. Currently fails because it depends on files the system ffmpeg doesn't install.
		rm -rf cmake/admFFmpeg* cmake/ffmpeg* avidemux_core/ffmpeg_package buildCore/ffmpeg || die "Failed to remove ffmpeg."

		sed -i -e 's/include(admFFmpegUtil)//g' avidemux/commonCmakeApplication.cmake || die "Failed to remove ffmpeg."
		sed -i -e '/registerFFmpeg/d' avidemux/commonCmakeApplication.cmake || die "Failed to remove ffmpeg."
		sed -i -e 's/include(admFFmpegBuild)//g' avidemux_core/CMakeLists.txt || die "Failed to remove ffmpeg."
	else
		# Avoid existing avidemux installations from making the build process fail, bug #461496.
		sed -i -e "s:getFfmpegLibNames(\"\${sourceDir}\"):getFfmpegLibNames(\"${S}/buildCore/ffmpeg/source/\"):g" cmake/admFFmpegUtil.cmake || die "Failed to avoid existing avidemux installation from making the build fail."
	fi
}

src_configure() {
	local mycmakeargs="
		-DAVIDEMUX_SOURCE_DIR='${S}'
		-DCMAKE_INSTALL_PREFIX='/usr'
		$(cmake-utils_use nls GETTEXT)
		$(cmake-utils_use sdl SDL)
		$(cmake-utils_use vdpau VDPAU)
		$(cmake-utils_use xv XVIDEO)
	"
	if use debug ; then
		mycmakeargs+=" -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug"
	fi

	local build="${S}"/buildCore
	mkdir ${build} || die "Can't create build folder."
	cd ${build} || die "Can't enter build folder."
	CMAKE_USE_DIR="${S}"/avidemux_core BUILD_DIR=${build} cmake-utils_src_configure
}

src_compile() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	# TODO: Report -j1 problem upstream, seems to be within ffmpeg code.
	cd "${S}"/buildCore || die "Can't enter build folder."
	emake -j1 CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	# TODO: Report -j1 problem upstream, seems to be within ffmpeg code.
	cd "${S}"/buildCore || die "Can't enter build folder."
	emake DESTDIR="${ED}" -j1 install

	dodoc "${S}"/{AUTHORS,README}
}
