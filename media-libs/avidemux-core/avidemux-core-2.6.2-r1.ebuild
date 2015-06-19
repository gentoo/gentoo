# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/avidemux-core/avidemux-core-2.6.2-r1.ebuild,v 1.10 2015/01/29 17:24:24 mgorny Exp $

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
IUSE="aften a52 alsa amr debug dts fontconfig jack lame libsamplerate cpu_flags_x86_mmx oss nls sdl -system-ffmpeg vorbis truetype xvid x264 xv"

RDEPEND="
	!<media-video/avidemux-2.6.2-r1:${SLOT}
	>=dev-lang/spidermonkey-1.5-r2:0
	dev-libs/libxml2
	media-libs/libpng
	virtual/libiconv
	aften? ( media-libs/aften )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	amr? ( media-libs/opencore-amr )
	dts? ( media-libs/libdca )
	fontconfig? ( media-libs/fontconfig )
	jack? (
		media-sound/jack-audio-connection-kit
		libsamplerate? ( media-libs/libsamplerate )
	)
	lame? ( media-sound/lame )
	sdl? ( media-libs/libsdl )
	system-ffmpeg? ( >=media-video/ffmpeg-1.0:0[aac,cpudetection,mp3,theora] )
	truetype? ( >=media-libs/freetype-2.1.5 )
	x264? ( media-libs/x264:= )
	xv? ( x11-libs/libXv )
	xvid? ( media-libs/xvid )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
RDEPEND="
	nls? ( virtual/libintl:0 )
	$RDEPEND
"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Preparations to support the system ffmpeg.
	if use system-ffmpeg ; then
		rm -rf cmake/admFFmpeg* cmake/ffmpeg* avidemux_core/ffmpeg_package buildCore/ffmpeg || die "Failed to remove ffmpeg."

		sed -i -e 's/include(admFFmpegUtil)//g' avidemux/commonCmakeApplication.cmake || die "Failed to remove ffmpeg."
		sed -i -e '/registerFFmpeg/d' avidemux/commonCmakeApplication.cmake || die "Failed to remove ffmpeg."
		sed -i -e 's/include(admFFmpegBuild)//g' avidemux_core/CMakeLists.txt || die "Failed to remove ffmpeg."
	fi

	# Avoid existing avidemux installations from making the build process fail, bug #461496.
	sed -i -e "s:getFfmpegLibNames(\"\${sourceDir}\"):getFfmpegLibNames(\"${S}/buildCore/ffmpeg/source/\"):g" cmake/admFFmpegUtil.cmake || die "Failed to avoid existing avidemux installation from making the build fail."
}

src_configure() {
	local x mycmakeargs

	mycmakeargs="
		$(for x in ${IUSE}; do cmake-utils_use ${x/#-/}; done)
		$(cmake-utils_use amr OPENCORE_AMRWB)
		$(cmake-utils_use amr OPENCORE_AMRNB)
		$(cmake-utils_use dts LIBDCA)
		$(cmake-utils_use nls GETTEXT)
		$(cmake-utils_use truetype FREETYPE2)
		$(cmake-utils_use xv XVIDEO)
	"
	use debug && POSTFIX="_debug" && mycmakeargs+="-DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug"

	mkdir "${S}"/buildCore || die "Can't creante build folder."
	cd "${S}"/buildCore || die "Can't enter build folder."

	cmake -DAVIDEMUX_SOURCE_DIR="${S}" \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		${mycmakeargs} -G "Unix Makefiles" ../"avidemux_core${POSTFIX}/" || die "cmake failed."
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
