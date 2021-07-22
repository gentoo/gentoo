# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
PYTHON_COMPAT=( python3_{8,9,10} )
inherit lua python-single-r1 cmake toolchain-funcs

DESCRIPTION="Open source multimedia framework for television broadcasting"
HOMEPAGE="https://www.mltframework.org/"
SRC_URI="https://github.com/mltframework/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/7"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug ffmpeg frei0r gtk jack kernel_linux libsamplerate lua opencv opengl python qt5 rtaudio rubberband sdl test vdpau vidstab xine xml"
# TODO: swig bindings for java perl php tcl

# Needs unpackaged 'kwalify'
RESTRICT="test"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

SWIG_DEPEND=">=dev-lang/swig-2.0"
#	java? ( ${SWIG_DEPEND} >=virtual/jdk-1.5 )
#	perl? ( ${SWIG_DEPEND} )
#	php? ( ${SWIG_DEPEND} )
#	tcl? ( ${SWIG_DEPEND} )
#	ruby? ( ${SWIG_DEPEND} )
BDEPEND="
	virtual/pkgconfig
	lua? ( ${SWIG_DEPEND} virtual/pkgconfig )
	python? ( ${SWIG_DEPEND} )
"
# rtaudio will use OSS on non linux OSes
DEPEND="
	>=media-libs/libebur128-1.2.2:=
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
	lua? ( ${LUA_DEPS} )
	opencv? ( >=media-libs/opencv-4.5.1:= )
	opengl? ( media-video/movit )
	python? ( ${PYTHON_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		media-libs/libexif
		sci-libs/fftw:3.0=
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
	xml? ( >=dev-libs/libxml2-2.5 )"
#	java? ( >=virtual/jre-1.5 )
#	perl? ( dev-lang/perl )
#	php? ( dev-lang/php )
#	ruby? ( ${RUBY_DEPS} )
#	sox? ( media-sound/sox )
#	tcl? ( dev-lang/tcl:0= )
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-6.10.0-swig-underlinking.patch
	"${FILESDIR}"/${PN}-6.22.1-no_lua_bdepend.patch
	"${FILESDIR}"/${PN}-7.0.1-cmake-symlink.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	local x
	for x in python lua; do
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" src/swig/${x}/build || die
	done

	use python && python_fix_shebang src/swig/python

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPL=ON
		-DGPL3=ON
		-DBUILD_TESTING=$(usex test)
		-DMOD_KDENLIVE=ON
		-DMOD_SDL1=OFF
		-DMOD_SDL2=$(usex sdl)
		-DMOD_AVFORMAT=$(usex ffmpeg)
		# TODO: does anything need plus?
		# plus or qt
		#$(use_enable fftw plus)
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_JACKRACK=$(usex jack)
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

	# TODO: We currently have USE=fftw but both Qt and plus require it, removing flag for now.
	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	local swig_lang=()
	# Not done: java perl php ruby tcl
	# Handled separately: lua
	for i in python; do
		use ${i} && mycmakeargs+=( -DSWIG_${i}=ON )
	done

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use lua; then
		# Only copy sources now to avoid unnecessary rebuilds
		lua_copy_sources

		lua_compile() {
			pushd "${BUILD_DIR}"/src/swig/lua > /dev/null || die

			sed -i -e "s| mlt_wrap.cxx| $(lua_get_CFLAGS) mlt_wrap.cxx|" build || die
			./build || die

			popd > /dev/null || die
		}
		lua_foreach_impl lua_compile
	fi
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	doins -r demo

	#
	# Install SWIG bindings
	#

	docinto swig

	if use lua; then
		lua_install() {
			pushd "${BUILD_DIR}"/src/swig/lua > /dev/null || die

			exeinto "$(lua_get_cmod_dir)"
			doexe mlt.so

			popd > /dev/null || die
		}
		lua_foreach_impl lua_install

		dodoc "${S}"/src/swig/lua/play.lua
	fi

	if use python; then
		cd "${S}"/src/swig/python || die

		python_domodule mlt.py _mlt.so
		chmod +x "${D}$(python_get_sitedir)/_mlt.so" || die
		dodoc play.py

		python_optimize
	fi

	# Not done: java perl php ruby tcl
}
