# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils flag-o-matic python-single-r1

SLOT="2.6"

DESCRIPTION="Plugins for avidemux; a video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
IUSE="aac aften a52 alsa amr debug dts fontconfig fribidi jack lame libsamplerate cpu_flags_x86_mmx opengl oss pulseaudio qt4 vorbis truetype twolame xv xvid x264 vdpau vpx"
KEYWORDS="~amd64 ~x86"

MY_PN="${PN/-plugins/}"
if [[ ${PV} == *9999* ]] ; then
	KEYWORDS=""
	EGIT_REPO_URI="git://gitorious.org/${MY_PN}2-6/${MY_PN}2-6.git https://git.gitorious.org/${MY_PN}2-6/${MY_PN}2-6.git"

	inherit git-2
else
	MY_P="${MY_PN}_${PV}"
	SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"
fi

DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[vdpau?]
	~media-video/avidemux-${PV}:${SLOT}[opengl?,qt4?]
	>=dev-lang/spidermonkey-1.5-r2:0=
	dev-libs/libxml2:2
	media-libs/libpng:0=
	virtual/libiconv:0
	aac? (
		media-libs/faac:0
		media-libs/faad2:0
	)
	aften? ( media-libs/aften:0 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2:0 )
	amr? ( media-libs/opencore-amr:0 )
	dts? ( media-libs/libdca:0 )
	fontconfig? ( media-libs/fontconfig:1.0 )
	fribidi? ( dev-libs/fribidi:0 )
	jack? (
		media-sound/jack-audio-connection-kit:0
		libsamplerate? ( media-libs/libsamplerate:0 )
	)
	lame? ( media-sound/lame:0 )
	oss? ( virtual/os-headers:0 )
	pulseaudio? ( media-sound/pulseaudio:0 )
	truetype? ( media-libs/freetype:2 )
	twolame? ( media-sound/twolame:0 )
	x264? ( media-libs/x264:0= )
	xv? (
		x11-libs/libX11:0
		x11-libs/libXext:0
		x11-libs/libXv:0
	)
	xvid? ( media-libs/xvid:0 )
	vorbis? ( media-libs/libvorbis:0 )
	vpx? ( media-libs/libvpx:0 )
	${PYTHON_DEPS}
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-2.6.4-optional-pulse.patch )

src_configure() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	processes="buildPluginsCommon:avidemux_plugins
		buildPluginsCLI:avidemux_plugins"
	use qt4 && processes+=" buildPluginsQt4:avidemux_plugins"

	for process in ${processes} ; do
		local build="${process%%:*}"

		local mycmakeargs="
			-DAVIDEMUX_SOURCE_DIR='${S}'
			-DPLUGIN_UI=$(echo ${build/buildPlugins/} | tr '[:lower:]' '[:upper:]')
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
			$(cmake-utils_use vdpau)
			$(cmake-utils_use vorbis)
			$(cmake-utils_use vorbis LIBVORBIS)
			$(cmake-utils_use vpx VPXDEC)
		"

		if use debug ; then
			mycmakeargs+=" -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug -DADM_DEBUG=1"
		fi

		mkdir "${S}"/${build} || die "Can't create build folder."

		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${S}"/${build} cmake-utils_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		BUILD_DIR="${S}/${process%%:*}" cmake-utils_src_compile
	done
}

src_install() {
	for process in ${processes} ; do
		# cmake-utils_src_install doesn't respect BUILD_DIR
		# and there sometimes is a preinstall phase present.
		pushd "${S}/${process%%:*}" > /dev/null || die
			grep '^preinstall/fast' Makefile && emake DESTDIR="${D}" preinstall/fast
			grep '^install/fast' Makefile && emake DESTDIR="${D}" install/fast
		popd > /dev/null || die
	done

	python_fix_shebang "${D}"
}
