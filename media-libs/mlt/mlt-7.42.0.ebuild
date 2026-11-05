# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit python-single-r1 cmake flag-o-matic locale-utils toolchain-funcs

DESCRIPTION="Open source multimedia framework for television broadcasting"
HOMEPAGE="https://www.mltframework.org/"
SRC_URI="https://github.com/mltframework/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1 gpl? ( GPL-2 GPL-3 )"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

IUSE="debug ffmpeg frei0r +gpl gtk jack ladspa libplacebo libsamplerate lv2 opencv openfx
opengl python qt6 rtaudio rnnoise rubberband sdl sox test vdpau vidstab vorbis xine xml"
REQUIRED_USE="
	ladspa? ( gpl jack )
	libsamplerate? ( gpl )
	lv2? ( gpl ladspa )
	openfx? ( gpl )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt6? ( gpl )
	rubberband? ( gpl )
	vidstab? ( gpl )
	xine? ( gpl )
"

RESTRICT="!test? ( test )"

# rtaudio will use OSS on non linux OSes
# Qt already needs FFTW/PLUS so let's just always have it on to ensure
# MLT is useful: bug #603168.
RDEPEND="
	>=media-libs/libebur128-1.2.2:=
	sci-libs/fftw:3.0=
	ffmpeg? ( media-video/ffmpeg:0=[vdpau?] )
	frei0r? ( media-plugins/frei0r-plugins )
	gtk? (
		media-libs/fontconfig
		media-libs/libexif
		x11-libs/gdk-pixbuf:2
		x11-libs/pango
	)
	jack? ( virtual/jack )
	ladspa? (
		dev-libs/glib:2
		>=dev-libs/libxml2-2.5:=
		media-libs/ladspa-sdk
	)
	libplacebo? ( >=media-libs/libplacebo-5.229:= )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	lv2? ( media-libs/lilv:= )
	opencv? (
		>=media-libs/opencv-4.5.1:=[contrib]
		|| (
			media-libs/opencv[ffmpeg]
			media-libs/opencv[gstreamer]
		)
	)
	openfx? ( dev-libs/glib:2 )
	opengl? (
		media-libs/libglvnd
		media-video/movit
	)
	python? ( ${PYTHON_DEPS} )
	qt6? (
		dev-qt/qtbase:6[gui,network,opengl,widgets,xml]
		dev-qt/qtsvg:6
		media-libs/libexif
		x11-libs/libX11
	)
	rtaudio? (
		>=media-libs/rtaudio-4.1.2:=
		kernel_linux? ( media-libs/alsa-lib )
	)
	rnnoise? ( media-libs/rnnoise:= )
	rubberband? ( media-libs/rubberband:= )
	sdl? (
		media-libs/libsdl2[X,opengl,video]
		media-libs/sdl2-image
	)
	sox? ( media-sound/sox:= )
	vidstab? ( media-libs/vidstab )
	vorbis? ( media-libs/libvorbis )
	xine? ( >=media-libs/xine-lib-1.1.2_pre20060328-r7 )
	xml? ( >=dev-libs/libxml2-2.5:= )
"
#	java? ( >=virtual/jre-1.8:* )
#	perl? ( dev-lang/perl )
#	php? ( dev-lang/php )
#	ruby? ( ${RUBY_DEPS} )
#	tcl? ( dev-lang/tcl:0= )
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6 )
"
BDEPEND="
	virtual/pkgconfig
	python? ( >=dev-lang/swig-2.0 )
"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	# downstream
	"${FILESDIR}"/${PN}-6.10.0-swig-underlinking.patch
	"${FILESDIR}"/${PN}-6.22.1-no_lua_bdepend.patch
	"${FILESDIR}"/${PN}-7.0.1-cmake-symlink.patch
	"${FILESDIR}"/${PN}-7.42.0-musl.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openfx && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openfx && tc-check-openmp
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	if use python; then
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" src/swig/python/build || die
		python_fix_shebang src/swig/python
	fi

	# Workaround kwalify dependency. Its not required on MSVC, we can ignore it as well.
	sed -e '/find_package(Kwalify/ s/REQUIRED//' -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Workaround for bug #919981
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	# match order in CMakeLists.txt
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON

		-DGPL=$(usex gpl)
		-DGPL3=$(usex gpl) # currently only enables GPL-3 code for the Qt Module
		-DBUILD_TESTING=$(usex test)
		-DCLANG_FORMAT=OFF
		-DBUILD_TESTS_WITH_QT6=ON # The tests use qttest, this switch decides whether qt5 or qt6 is used.

		-DMOD_AVFORMAT=$(usex ffmpeg)
		-DUSE_AVDEVICE=$(usex ffmpeg)
		#-DMOD_DECKLINK=
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_GLAXNIMATE_QT6=$(usex qt6)
		-DMOD_JACKRACK=$(usex jack)
		-DUSE_LADSPA=$(usex ladspa) # GPL
		-DUSE_LV2=$(usex lv2) # GPL
		-DUSE_VST2=$(usex ladspa) # GPL
		-DMOD_KDENLIVE=ON
		-DMOD_MOVIT=$(usex opengl)
		#-DMOD_NDI=
		#-DMOD_NORMALIZE= # GPL
		#-DMOD_OLDFILM=
		-DMOD_OPENCV=$(usex opencv)
		-DMOD_OPENFX=$(usex openfx) # GPL
		-DMOD_PLACEBO=$(usex libplacebo)
		-DMOD_PLUS=ON
		#-DMOD_PLUSGPL=
		-DMOD_QT6=$(usex qt6) # GPL
		-DMOD_RESAMPLE=$(usex libsamplerate) # GPL
		-DMOD_RTAUDIO=$(usex rtaudio)
		-DMOD_RUBBERBAND=$(usex rubberband) # GPL
		-DMOD_RNNOISE=$(usex rnnoise)
		-DMOD_SDL1=OFF
		-DMOD_SDL2=$(usex sdl)
		-DMOD_SOX=$(usex sox)
		-DMOD_SPATIALAUDIO=OFF # TODO: package libspatialaudio
		-DMOD_VIDSTAB=$(usex vidstab) # GPL
		-DMOD_VORBIS=$(usex vorbis)
		-DMOD_XINE=$(usex xine) # GPL
		-DMOD_XML=$(usex xml)
	)

	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings?
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	if use python; then
		mycmakeargs+=(
			-DSWIG_PYTHON=ON
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi

	cmake_src_configure
}

src_test() {
	# see setenv in upstream repository
	local -x MLT_REPOSITORY="${BUILD_DIR}/out/lib/mlt"
	local -x MLT_DATA="${BUILD_DIR}/out/share/mlt"
	local -x MLT_PROFILES_PATH="${BUILD_DIR}/out/share/mlt/profiles"
	local -x MLT_PRESETS_PATH="${BUILD_DIR}/out/share/mlt/presets"
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/out/lib:${LD_LIBRARY_PATH}"
	local -x PATH="${BUILD_DIR}/out/bin:${PATH}"

	local -x QT_QPA_PLATFORM=offscreen

	local CMAKE_SKIP_TESTS=()
	use !xml && CMAKE_SKIP_TESTS+=( QtTest:xml )

	# Get locales used in test_properties (see p.set_lcnumeric), bug #980672
	if ! elocale_gen en_US.UTF-8 de_DE.UTF-8; then
		CMAKE_SKIP_TESTS+=( QtTest:properties )
	fi

	cmake_src_test
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	doins -r demo

	#
	# Install SWIG bindings
	#

	docinto swig

	if use python; then
		dodoc "${S}"/src/swig/python/play.py
		python_optimize
	fi
}
