# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"

inherit cmake-utils eutils flag-o-matic l10n toolchain-funcs

SLOT="2.6"
MY_PN="${PN/-plugins/}"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Plugins for avidemux; a video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="mirror://sourceforge/${MY_PN}/${PV}/${MY_P}.tar.gz"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
KEYWORDS="~amd64 ~x86"
IUSE="aac aften a52 alsa amr debug dts fontconfig fribidi jack lame libsamplerate cpu_flags_x86_mmx opengl oss pulseaudio qt4 vorbis truetype twolame xv xvid x264 vpx"

DEPEND="
	~media-video/avidemux-${PV}[opengl?,qt4?]
	>=dev-lang/spidermonkey-1.5-r2:0
	dev-libs/libxml2
	media-libs/libpng
	virtual/libiconv
	aac? (
		media-libs/faac
		media-libs/faad2
	)
	aften? ( media-libs/aften )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	amr? ( media-libs/opencore-amr )
	dts? ( media-libs/libdca )
	fontconfig? ( media-libs/fontconfig )
	fribidi? ( dev-libs/fribidi )
	jack? (
		media-sound/jack-audio-connection-kit
		libsamplerate? ( media-libs/libsamplerate )
	)
	lame? ( media-sound/lame )
	oss? ( virtual/os-headers )
	pulseaudio? ( media-sound/pulseaudio )
	truetype? ( media-libs/freetype:2 )
	twolame? ( media-sound/twolame )
	x264? ( media-libs/x264:= )
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
	)
	xvid? ( media-libs/xvid )
	vorbis? ( media-libs/libvorbis )
	vpx? ( media-libs/libvpx )
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${MY_P}"

processes="buildPluginsCommon:avidemux_plugins
	buildPluginsCLI:avidemux_plugins"

use qt4 && processes+=" buildPluginsQt4:avidemux_plugins"

src_prepare() {
	epatch "${FILESDIR}"/${P}-optional-pulse.patch
}

src_configure() {
	for process in ${processes} ; do
		local mycmakeargs="
			-DAVIDEMUX_SOURCE_DIR='${S}'
			-DCMAKE_INSTALL_PREFIX='/usr'
			$(cmake-utils_use aac FAAC)
			$(cmake-utils_use aac FAAD)
			$(cmake-utils_use alsa)
			$(cmake-utils_use aften)
			$(cmake-utils_use amr OPENCORE_AMRWB)
			$(cmake-utils_use amr OPENCORE_AMRNB)
			$(cmake-utils_use dts LIBDCA)
			$(cmake-utils_use fontconfig)
			$(cmake-utils_use jack)
			$(cmake-utils_use lame)
			$(cmake-utils_use oss)
			$(cmake-utils_use pulseaudio PULSEAUDIOSIMPLE)
			$(cmake-utils_use qt4)
			$(cmake-utils_use truetype FREETYPE2)
			$(cmake-utils_use twolame)
			$(cmake-utils_use x264)
			$(cmake-utils_use xv XVIDEO)
			$(cmake-utils_use xvid)
			$(cmake-utils_use vorbis)
			$(cmake-utils_use vorbis LIBVORBIS)
			$(cmake-utils_use vpx VPXDEC)
		"

		if use debug ; then
			mycmakeargs+=" -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug"
		fi

		local build="${process%%:*}"

		if [[ "${build}" == "buildPluginsCommon" ]] ; then
			mycmakeargs+=" -DPLUGIN_UI=COMMON"
		elif [[ "${build}" == "buildPluginsCLI" ]] ; then
			mycmakeargs+=" -DPLUGIN_UI=CLI"
		elif [[ "${build}" == "buildPluginsQt4" ]] ; then
			mycmakeargs+=" -DPLUGIN_UI=QT4"
		fi

		mkdir "${S}"/${build} || die "Can't create build folder."
		cd "${S}"/${build} || die "Can't enter build folder."

		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${S}"/${build} cmake-utils_src_configure
	done
}

src_compile() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for process in ${processes} ; do
		cd "${S}"/${process%%:*} || die "Can't enter build folder."
		emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	done
}

src_install() {
	for process in ${processes} ; do
		cd "${S}"/${process%%:*} || die "Can't enter build folder."
		emake DESTDIR="${ED}" install
	done
}
