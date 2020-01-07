# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
# this ebuild currently only supports installing ruby bindings for a single ruby version
# so USE_RUBY must contain only a single value (the latest stable) as the ebuild calls
# /usr/bin/${USE_RUBY} directly
USE_RUBY="ruby26"
inherit python-single-r1 qmake-utils ruby-single toolchain-funcs

DESCRIPTION="Open source multimedia framework for television broadcasting"
HOMEPAGE="https://www.mltframework.org/"
SRC_URI="https://github.com/mltframework/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="compressed-lumas cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 debug ffmpeg
fftw frei0r gtk jack kdenlive kernel_linux libav libsamplerate lua melt opencv opengl python
qt5 rtaudio ruby sdl vdpau vidstab xine xml"
# java perl php tcl

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

SWIG_DEPEND=">=dev-lang/swig-2.0"
#	java? ( ${SWIG_DEPEND} >=virtual/jdk-1.5 )
#	perl? ( ${SWIG_DEPEND} )
#	php? ( ${SWIG_DEPEND} )
#	tcl? ( ${SWIG_DEPEND} )
BDEPEND="
	virtual/pkgconfig
	compressed-lumas? ( virtual/imagemagick-tools[png] )
	lua? ( ${SWIG_DEPEND} virtual/pkgconfig )
	python? ( ${SWIG_DEPEND} )
	ruby? ( ${SWIG_DEPEND} )"
#rtaudio will use OSS on non linux OSes
DEPEND="
	>=media-libs/libebur128-1.2.2:=
	ffmpeg? (
		libav? ( >=media-video/libav-12:0=[vdpau?] )
		!libav? ( media-video/ffmpeg:0=[vdpau?,-flite] )
	)
	fftw? ( sci-libs/fftw:3.0= )
	frei0r? ( media-plugins/frei0r-plugins )
	gtk? (
		media-libs/libexif
		x11-libs/gtk+:2
		x11-libs/pango
	)
	jack? (
		>=dev-libs/libxml2-2.5
		media-libs/ladspa-sdk
		virtual/jack
	)
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	lua? ( >=dev-lang/lua-5.1.4-r4:= )
	opencv? ( >=media-libs/opencv-3.2.0:= )
	opengl? ( media-video/movit )
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
	ruby? ( ${RUBY_DEPS} )
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
#	sox? ( media-sound/sox )
#	tcl? ( dev-lang/tcl:0= )
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README docs/{framework,melt,mlt{++,-xml}}.txt )

PATCHES=( "${FILESDIR}"/${PN}-6.10.0-swig-underlinking.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	for x in python lua; do
		sed -i "/mlt.so/s: -lmlt++ :& ${CFLAGS} ${LDFLAGS} :" src/swig/$x/build || die
	done

	sed -i -e "s/env ruby/${USE_RUBY}/" src/swig/ruby/* || die

	use python && python_fix_shebang src/swig/python
}

src_configure() {
	tc-export CC CXX

	local myconf=(
		--enable-gpl
		--enable-gpl3
		--enable-motion-est
		--target-arch=$(tc-arch)
		--disable-kde
		--disable-sdl
		--disable-swfdec
		$(use_enable debug)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable ffmpeg avformat)
		$(use_enable fftw plus)
		$(use_enable frei0r)
		$(use_enable gtk gtk2)
		$(use_enable jack jackrack)
		$(use_enable kdenlive)
		$(use_enable libsamplerate resample)
		$(use_enable melt)
		$(use_enable opencv)
		$(use_enable opengl)
		$(use_enable qt5 qt)
		$(use_enable rtaudio)
		$(use_enable sdl sdl2)
		$(use_enable vidstab vid.stab )
		$(use_enable xine)
		$(use_enable xml)
		--disable-sox
	)
		#$(use_enable sox) FIXME

	use compressed-lumas && myconf+=( --luma-compress )
	use ffmpeg && myconf+=( --avformat-swscale )
	use vdpau && myconf+=( --avformat-vdpau )

	if use qt5 ; then
		myconf+=(
			--qt-includedir=$(qt5_get_headerdir)
			--qt-libdir=$(qt5_get_libdir)
		)
	fi

	if use amd64 || use x86 ; then
		myconf+=( $(use_enable cpu_flags_x86_mmx mmx) )
	else
		myconf+=( --disable-mmx )
	fi

	if ! use melt ; then
		sed -i -e "s;src/melt;;" Makefile || die
	fi

	# TODO: add swig language bindings
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	local swig_lang=()
	# TODO: java perl php tcl
	for i in lua python ruby ; do
		use $i && swig_lang+=( $i )
	done
	[[ -z "${swig_lang}" ]] && swig_lang=( none )

	econf "${myconf[@]}" --swig-languages="${swig_lang[*]}"

	sed -i -e s/^OPT/#OPT/ config.mak || die
}

src_install() {
	default

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r demo

	docinto swig

	# Install SWIG bindings
	if use lua; then
		cd "${S}"/src/swig/lua || die
		exeinto $(pkg-config --variable INSTALL_CMOD lua)
		doexe mlt.so
		dodoc play.lua
	fi

	if use python; then
		cd "${S}"/src/swig/python || die
		python_domodule mlt.py _mlt.so
		chmod +x "${D}$(python_get_sitedir)/_mlt.so" || die
		dodoc play.py
		python_optimize
	fi

	if use ruby; then
		cd "${S}"/src/swig/ruby || die
		local rubydir=$("${EPREFIX}"/usr/bin/${USE_RUBY} -r rbconfig -e 'print RbConfig::CONFIG["sitearchdir"]')
		exeinto "${rubydir#${EPREFIX}}"
		doexe mlt.so
		dodoc play.rb thumbs.rb
	fi
	# TODO: java perl php tcl
}
