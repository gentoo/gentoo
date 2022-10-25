# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-single-r1 cmake

DESCRIPTION="Open source multimedia framework for television broadcasting"
HOMEPAGE="https://www.mltframework.org/"
SRC_URI="https://github.com/mltframework/${PN}/releases/download/v${PV}/${P}.tar.gz -> ${P}a.tar.gz"

LICENSE="GPL-3"
SLOT="0/7"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="debug ffmpeg frei0r gtk jack libsamplerate opencv opengl python qt5 rtaudio rubberband sdl test vdpau vidstab xine xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Needs unpackaged 'kwalify'
RESTRICT="test"

# rtaudio will use OSS on non linux OSes
# Qt already needs FFTW/PLUS so let's just always have it on to ensure
# MLT is useful: bug #603168.
DEPEND="
	>=media-libs/libebur128-1.2.2:=
	sci-libs/fftw:3.0=
	ffmpeg? ( media-video/ffmpeg:0=[vdpau?,-flite] )
	frei0r? ( media-plugins/frei0r-plugins )
	gtk? (
		media-libs/libexif
		x11-libs/pango
	)
	jack? (
		>=dev-libs/libxml2-2.5
		media-libs/ladspa-sdk
		virtual/jack
	)
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	opencv? ( >=media-libs/opencv-4.5.1:=[contrib] )
	opengl? (
		media-libs/libglvnd
		media-video/movit
	)
	python? ( ${PYTHON_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		media-libs/libexif
		x11-libs/libX11
	)
	rtaudio? (
		>=media-libs/rtaudio-4.1.2
		kernel_linux? ( media-libs/alsa-lib )
	)
	rubberband? ( media-libs/rubberband )
	sdl? (
		media-libs/libsdl2[X,opengl,video]
		media-libs/sdl2-image
	)
	vidstab? ( media-libs/vidstab )
	xine? ( >=media-libs/xine-lib-1.1.2_pre20060328-r7 )
	xml? ( >=dev-libs/libxml2-2.5 )
"
#	java? ( >=virtual/jre-1.8:* )
#	perl? ( dev-lang/perl )
#	php? ( dev-lang/php )
#	ruby? ( ${RUBY_DEPS} )
#	sox? ( media-sound/sox )
#	tcl? ( dev-lang/tcl:0= )
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	python? ( >=dev-lang/swig-2.0 )
"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-6.10.0-swig-underlinking.patch
	"${FILESDIR}"/${PN}-6.22.1-no_lua_bdepend.patch
	"${FILESDIR}"/${PN}-7.0.1-cmake-symlink.patch
	"${FILESDIR}"/${PN}-7.8.0-linux_locale_h.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	if use python; then
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" src/swig/python/build || die
		python_fix_shebang src/swig/python
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_WITH_QT6=OFF
		-DGPL=ON
		-DGPL3=ON
		-DBUILD_TESTING=$(usex test)
		-DMOD_KDENLIVE=ON
		-DMOD_SDL1=OFF
		-DMOD_SDL2=$(usex sdl)
		-DMOD_AVFORMAT=$(usex ffmpeg)
		-DMOD_PLUS=ON
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_JACKRACK=$(usex jack)
		-DMOD_GLAXNIMATE=OFF
		-DMOD_RESAMPLE=$(usex libsamplerate)
		-DMOD_OPENCV=$(usex opencv)
		-DMOD_MOVIT=$(usex opengl)
		-DMOD_QT=$(usex qt5)
		-DMOD_RTAUDIO=$(usex rtaudio)
		-DMOD_RUBBERBAND=$(usex rubberband)
		-DMOD_VIDSTAB=$(usex vidstab)
		-DMOD_XINE=$(usex xine)
		-DMOD_XML=$(usex xml)
		-DMOD_SOX=OFF
	)

	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings?
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	if use python; then
		mycmakeargs+=( -DSWIG_PYTHON=ON )
	fi

	cmake_src_configure
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
