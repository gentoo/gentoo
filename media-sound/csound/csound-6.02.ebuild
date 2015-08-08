# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils multilib java-pkg-opt-2 cmake-utils toolchain-funcs versionator python-single-r1

MY_PN="${PN/c/C}"
MY_P="${MY_PN}${PV}"

DESCRIPTION="A sound design and signal processing system providing facilities for composition and performance"
HOMEPAGE="http://csounds.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa beats chua csoundac curl +cxx debug double-precision dssi examples fltk +fluidsynth
+image jack java keyboard linear lua luajit nls osc openmp portaudio portmidi pulseaudio
python samples score static-libs stk tcl test +threads +utils vim-syntax"

LANGS=" de en_US es_CO fr it ro ru"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	>=media-libs/libsndfile-1.0.16
	alsa? ( media-libs/alsa-lib )
	csoundac? (
		x11-libs/fltk:1[threads?]
		dev-cpp/eigen:3
		dev-libs/boost
		${PYTHON_DEPS}
	)
	curl? ( net-misc/curl )
	dssi? (
		media-libs/dssi
		media-libs/ladspa-sdk
	)
	fluidsynth? ( media-sound/fluidsynth )
	fltk? ( x11-libs/fltk:1[threads?] )
	image? ( media-libs/libpng:0= )
	jack? ( media-sound/jack-audio-connection-kit )
	java? ( >=virtual/jdk-1.5 )
	keyboard? ( x11-libs/fltk:1[threads?] )
	linear? ( sci-mathematics/gmm )
	lua? (
		luajit? ( dev-lang/luajit:2 )
		!luajit? ( dev-lang/lua:0 )
	)
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	python? ( ${PYTHON_DEPS} )
	stk? ( media-libs/stk )
	tcl? (
		>=dev-lang/tcl-8.5:0=
		>=dev-lang/tk-8.5:0=
	)
	utils? ( !media-sound/snd )
"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	chua? ( dev-libs/boost )
	csoundac? ( dev-lang/swig )
	nls? ( sys-devel/gettext )
	test? (
		dev-util/cunit
		${PYTHON_DEPS}
	)
"
REQUIRED_USE="
	java? ( cxx )
	linear? ( double-precision )
	lua? ( cxx )
	python? ( cxx )
"

# requires specific alsa settings
RESTRICT="test"

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

pkg_setup() {
	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-porttime-in-portmidi.patch

	sed -e '/set(PLUGIN_INSTALL_DIR/s/-${APIVERSION}//' \
		-e '/-O3/d' \
		-i CMakeLists.txt || die

	if use python ; then
		sed -i "/set(PYTHON_MODULE_INSTALL_DIR/s#\${LIBRARY_INSTALL_DIR}#$(python_get_sitedir)#" CMakeLists.txt || die
	fi

	for lang in ${LANGS} ; do
		if ! use linguas_${lang} ; then
			sed -i "/compile_po(${lang}/d" po/CMakeLists.txt || die
		fi
	done
}

src_configure() {
	local myconf

	if use csoundac ; then
		myconf+=" -DBUILD_CSOUND_AC_PYTHON_INTERFACE=$(usex python ON OFF)"
		myconf+=" -DBUILD_CSOUND_AC_LUA_INTERFACE=$(usex lua ON OFF)"
	fi

	[[ $(get_libdir) == "lib64" ]] && myconf+=" -DUSE_LIB64=ON"

	local mycmakeargs=(
		$(cmake-utils_use_use alsa ALSA)
		$(cmake-utils_use_build beats CSBEATS)
		$(cmake-utils_use_build chua CHUA_OPCODES)
		$(cmake-utils_use_build csoundac CSOUND_AC)
		$(cmake-utils_use_build cxx CXX_INTERFACE)
		$(cmake-utils_use_use curl CURL)
		$(cmake-utils_use debug NEW_PARSER_DEBUG)
		$(cmake-utils_use_use double-precision DOUBLE)
		$(cmake-utils_use_build dssi DSSI_OPCODES)
		$(cmake-utils_use_build fluidsynth FLUID_OPCODES)
		$(cmake-utils_use_use fltk FLTK)
		$(cmake-utils_use_build image IMAGE_OPCODES)
		$(cmake-utils_use_use jack JACK)
		$(cmake-utils_use_build jack JACK_OPCODES)
		$(cmake-utils_use_build java JAVA_INTERFACE)
		$(cmake-utils_use_build keyboard VIRTUAL_KEYBOARD)
		$(cmake-utils_use_build linear LINEAR_ALGEBRA_OPCODES)
		$(cmake-utils_use_build lua LUA_OPCODES)
		$(cmake-utils_use_build lua LUA_INTERFACE)
		$(cmake-utils_use_use nls GETTEXT)
		$(cmake-utils_use_build osc OSC_OPCODES)
		$(cmake-utils_use_use openmp OPEN_MP)
		$(cmake-utils_use_use portaudio PORTAUDIO)
		$(cmake-utils_use_use portmidi PORTMIDI)
		$(cmake-utils_use_use pulseaudio PULSEAUDIO)
		$(cmake-utils_use_build python PYTHON_OPCODES)
		$(cmake-utils_use_build python PYTHON_INTERFACE)
		$(cmake-utils_use score SCORE_PARSER)
		$(cmake-utils_use_build static-libs STATIC_LIBRARY)
		$(cmake-utils_use_build stk STK_OPCODES)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_build test STATIC_LIBRARY)
		$(cmake-utils_use_build tcl TCLCSOUND)
		$(cmake-utils_use_build threads MULTI_CORE)
		$(cmake-utils_use_build utils UTILITIES)
		-DBUILD_RELEASE=ON
		${myconf}
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	dodoc AUTHORS ChangeLog readme-csound6.txt What_is_New.txt \
		Release_Notes/* Known_Problems todo.txt To-fix-and-do

	# Generate env.d file
	if use double-precision ; then
		echo OPCODEDIR64=/usr/$(get_libdir)/${PN}/plugins64 > "${T}"/62${PN}
	else
		echo OPCODEDIR=/usr/$(get_libdir)/${PN}/plugins > "${T}"/62${PN}
	fi
	echo "CSSTRNGS=/usr/share/locale" >> "${T}"/62${PN}
	use stk && echo "RAWWAVE_PATH=/usr/share/csound/rawwaves" >> "${T}"/62${PN}
	doenvd "${T}"/62${PN}

	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	use samples && dodoc -r samples

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins installer/misc/vim/csound_{csd,orc,sco}.vim
		insinto /usr/share/vim/vimfiles/plugin
		doins installer/misc/vim/csound.vim
	fi

	# rename extract to csound_extract (bug #247394)
	mv "${ED}"/usr/bin/{extract,csound_extract} || die

	use python && python_optimize
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		elog "The extract tool is now installed as csound_extract"
		elog "due to collisions with many other packages (bug #247394)."
		elog
	fi
}
