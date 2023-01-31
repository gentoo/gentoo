# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit cmake wxwidgets xdg

MY_P="Audacity-${PV}"
DOC_PV="${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://web.audacityteam.org/"

# A header-only thread pool library, without a build system, about 100
# lines of code.  Probably not worth packaging individually.  Check
# cmake-proxies/CMakeLists.txt and search for "ThreadPool".
MY_THREADPOOL_DATE=20140926
MY_THREADPOOL="https://raw.githubusercontent.com/progschj/ThreadPool/9a42ec1329f259a5f4881a291db1dcb8f2ad9040/ThreadPool.h -> progschj-ThreadPool-${MY_THREADPOOL_DATE}.h"
SRC_URI="https://github.com/audacity/audacity/archive/${MY_P}.tar.gz
	doc? ( https://github.com/audacity/audacity-manual/releases/download/v${PV}/audacity-manual-${PV}.tar.gz )
	audiocom? ( ${MY_THREADPOOL} )"
S="${WORKDIR}/${PN}-${MY_P}"

# GPL-2+, GPL-3 - Audacity itself
# ZLIB - The ThreadPool single-header library
# CC-BY-3.0 - Documentation
LICENSE="GPL-2+
	GPL-3
	doc? ( CC-BY-3.0 )
	audiocom? ( ZLIB )
"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="alsa audiocom doc ffmpeg +flac id3tag +ladspa +lv2 mad mpg123 ogg
	opus +portmixer sbsms twolame vamp +vorbis wavpack"

# The testsuite consists of two tests, 50% of which fail.
RESTRICT="test"

# dev-db/sqlite:3 hard dependency.
# dev-libs/glib:2, x11-libs/gtk+:3 hard dependency, from
#   cmake-proxies/cmake-modules/dependencies/wxwidgets.cmake
# sys-apps/util-linux hard dependency, from cmake-proxies/CMakeLists.txt
#   for libuuid
# portmidi became non-optional: building without it results in build
#   failures, even with some of the Debian patches.  It's probably not
#   in our best interest to fix that as a patch series.
# glib, gtk and gdk are all directly relied on in the source, not just

# Libraries used at runtime via dlopen:
# - dev-libs/{serd,sord} - for LV2 support
# - media-libs/{opus,sratom} :: For Opus and LV2 respectively
# - media-sound/lame :: For MP3 export
# - media-video/ffmpeg :: For generic FFMPEG export
#   This one has the interesting property of many versions being
#   supported at runtime.  See: libraries/lib-ffmpeg-support/impl
#   Current support grid:
#   - Lavf - 5[789]
#   - Lavc - 5[789]
#   - Lavu - 5[2567]

RDEPEND="dev-db/sqlite:3
	dev-libs/expat
	dev-libs/glib:2
	media-libs/libsndfile
	media-libs/libsoundtouch:=
	media-libs/portaudio[alsa?]
	media-libs/portmidi
	media-libs/portsmf:=
	media-libs/soxr
	media-sound/lame
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	sys-apps/util-linux
	alsa? ( media-libs/alsa-lib )
	audiocom? (
		dev-libs/rapidjson
		net-misc/curl
	)
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac:=[cxx] )
	id3tag? ( media-libs/libid3tag:= )
	lv2? (
		dev-libs/serd
		dev-libs/sord
		media-libs/lilv
		media-libs/lv2
		media-libs/sratom
		media-libs/suil
	)
	mad? ( media-libs/libmad )
	mpg123? ( media-sound/mpg123 )
	ogg? ( media-libs/libogg )
	opus? ( media-libs/opus )
	sbsms? ( media-libs/libsbsms )
	twolame? ( media-sound/twolame )
	vamp? ( media-libs/vamp-plugin-sdk )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	sys-devel/gettext
	virtual/pkgconfig
"

REQUIRED_USE="
	mad? ( !mpg123 )
"

PATCHES=(
	# Equivalent to previous versions
	"${FILESDIR}/${PN}-3.2.3-disable-ccache.patch"
	# From Debian
	"${FILESDIR}/${PN}-3.2.3-fix-rpaths.patch"

	# Disables some header-based detection
	"${FILESDIR}/${PN}-3.2.3-allow-overriding-alsa-jack.patch"

	# For has_networking
	"${FILESDIR}/${PN}-3.2.3-remove-conan-threadpool.patch"
	"${FILESDIR}/${PN}-3.2.3-allow-finding-rapidjson-pkgconfig.patch"
)

src_prepare() {
	cmake_src_prepare

	local header_subs="${S}/lib-src/header-substitutes"
	cat <<-EOF >"${header_subs}/allegro.h" || die
	/* Hack the allegro.h header substitute to use system headers.  */
	#include <portsmf/allegro.h>
	EOF

	# Keep in sync with has_networking and the ThreadPool.h SRC_URI.
	if use audiocom; then
		mkdir -p "${S}/"/lib-src/threadpool/ThreadPool/ || die
		cp "${DISTDIR}"/progschj-ThreadPool-"${MY_THREADPOOL_DATE}".h \
		   "${S}"/lib-src/threadpool/ThreadPool/ThreadPool.h || die
	fi
}

src_configure() {
	setup-wxwidgets

	# * always use system libraries if possible
	# * options listed roughly in the order specified in
	#   cmake-proxies/CMakeLists.txt
	# * USE_VST was omitted, it appears to no longer have dependencies
	#   (this is different from VST3)
	local mycmakeargs=(
		# Tell the CMake-based build system it's building a release.
		-DAUDACITY_BUILD_LEVEL=2
		-Daudacity_use_nyquist=local
		#-Daudacity_use_pch leaving it to the default behavior
		-Daudacity_use_portmixer=$(usex portmixer system off)
		-Daudacity_use_soxr=system

		-Daudacity_conan_enabled=OFF

		-Daudacity_has_networking=$(usex audiocom on off)
		# Not useful on Gentoo.
		-Daudacity_has_updates_check=OFF
		-Daudacity_has_audiocom_upload=$(usex audiocom on off)
		-Daudacity_has_threadpool=local

		# The VST3 SDK is unpackaged, and it appears to be under a breed
		# of a proprietary license and the GPL.
		-Daudacity_has_vst3=OFF
		-Daudacity_lib_preference=system
		-Daudacity_obey_system_dependencies=ON
		-Daudacity_use_expat=system
		-Daudacity_use_ffmpeg=$(usex ffmpeg loaded off)
		-Daudacity_use_libid3tag=$(usex id3tag system off)
		-Daudacity_use_ladspa=$(usex ladspa)
		-Daudacity_use_lame=system
		-Daudacity_use_wxwidgets=system
		-Daudacity_use_libmp3lame=system
		-Daudacity_use_libmpg123=$(usex mpg123 system off)
		-Daudacity_use_libmad=$(usex mad system off)
		-Daudacity_use_wavpack=$(usex wavpack system off)
		-Daudacity_use_libogg=$(usex ogg system off)
		-Daudacity_use_libflac=$(usex flac system off)
		-Daudacity_use_libopus=$(usex flac system off)
		-Daudacity_use_libvorbis=$(usex vorbis system off)
		-Daudacity_use_libsndfile=system
		-Daudacity_use_portaudio=system
		-Daudacity_use_midi=system
		-Daudacity_use_vamp=$(usex vamp system off)
		-Daudacity_use_lv2=$(usex lv2 system off)
		-Daudacity_use_portsmf=system
		-Daudacity_use_sbsms=$(usex sbsms system off)
		-Daudacity_use_soundtouch=system
		-Daudacity_use_twolame=$(usex twolame system off)

		# Disable telemetry features.
		-Daudacity_has_sentry_reporting=off
		-Daudacity_has_crashreports=off

		# See the allow-overriding-alsa-jack.patch patch
		-DPA_HAS_ALSA=$(usex alsa on off)
		## Keep watch of PA_HAS_OSS in lib-src/portmixer/CMakeLists.txt;
		## AFAICT it introduces no deps as-is, but that could change.
		## Similar goes for PA_HAS_JACK.
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Remove bad doc install
	rm -r "${ED}"/usr/share/doc || die

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/help/manual/{m,man}
		dodoc "${WORKDIR}"/help/manual/{favicon.ico,index.html,quick_help.html}
		dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
	fi
}
