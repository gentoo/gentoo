# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils multilib java-pkg-opt-2 cmake-utils toolchain-funcs versionator python-single-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/csound/csound.git"
	inherit git-r3
else
	SRC_URI="https://github.com/csound/csound/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A sound design and signal processing system providing facilities for composition and performance"
HOMEPAGE="http://csound.github.io/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+alsa beats chua csoundac curl +cxx debug double-precision dssi examples
fltk +fluidsynth +image jack java keyboard linear lua luajit nls osc openmp
portaudio portmidi pulseaudio python samples score static-libs stk tcl test
+threads +utils vim-syntax websocket"

LANGS=" de en_US es_CO fr it ro ru"
IUSE+="${LANGS// / linguas_}"

REQUIRED_USE="
	csoundac? ( || ( lua python ) )
	java? ( cxx )
	linear? ( double-precision )
	lua? ( cxx )
	python? ( ${PYTHON_REQUIRED_USE} cxx )
"

RDEPEND="
	>=media-libs/libsndfile-1.0.16
	media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	csoundac? (
		x11-libs/fltk:1[threads?]
		dev-cpp/eigen:3
		dev-libs/boost:=
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
	java? ( virtual/jdk )
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
	websocket? ( net-libs/libwebsockets )
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

# requires specific alsa settings
RESTRICT="test"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	local PATCHES=( "${FILESDIR}"/csound-6.05-python.patch )

	sed -e '/set(PLUGIN_INSTALL_DIR/s/-${APIVERSION}//' \
		-e '/-O3/d' \
		-i CMakeLists.txt || die

	for lang in ${LANGS} ; do
		if ! use linguas_${lang} ; then
			sed -i "/compile_po(${lang}/d" po/CMakeLists.txt || die
		fi
	done

	default
}

src_configure() {
	local myconf=()

	use python && myconf+=( "-DPYTHON_MODULE_INSTALL_DIR=$(python_get_sitedir)" )

	[[ $(get_libdir) == "lib64" ]] && myconf+=( -DUSE_LIB64=ON )

	local mycmakeargs=(
		-DUSE_ALSA=$(usex alsa)
		-DBUILD_CSBEATS=$(usex beats)
		-DBUILD_CHUA_OPCODES=$(usex chua)
		-DBUILD_CSOUND_AC=$(usex csoundac)
		-DBUILD_CSOUND_AC_LUA_INTERFACE=$(usex csoundac $(usex lua))
		-DBUILD_CSOUND_AC_PYTHON_INTERFACE=$(usex csoundac $(usex python))
		-DBUILD_CXX_INTERFACE=$(usex cxx)
		-DUSE_CURL=$(usex curl)
		-DNEW_PARSER_DEBUG=$(usex debug)
		-DUSE_DOUBLE=$(usex double-precision)
		-DBUILD_DSSI_OPCODES=$(usex dssi)
		-DBUILD_FLUID_OPCODES=$(usex fluidsynth)
		-DUSE_FLTK=$(usex fltk)
		-DBUILD_IMAGE_OPCODES=$(usex image)
		-DUSE_JACK=$(usex jack)
		-DBUILD_JACK_OPCODES=$(usex jack)
		-DBUILD_JAVA_INTERFACE=$(usex java)
		-DBUILD_VIRTUAL_KEYBOARD=$(usex keyboard)
		-DBUILD_LINEAR_ALGEBRA_OPCODES=$(usex linear)
		-DBUILD_LUA_OPCODES=$(usex lua)
		-DBUILD_LUA_INTERFACE=$(usex lua)
		-DUSE_GETTEXT=$(usex nls)
		-DBUILD_OSC_OPCODES=$(usex osc)
		-DUSE_OPEN_MP=$(usex openmp)
		-DUSE_PORTAUDIO=$(usex portaudio)
		-DUSE_PORTMIDI=$(usex portmidi)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DBUILD_PYTHON_OPCODES=$(usex python)
		-DBUILD_PYTHON_INTERFACE=$(usex python)
		-DSCORE_PARSER=$(usex score)
		-DBUILD_STATIC_LIBRARY=$(usex static-libs)
		-DBUILD_STK_OPCODES=$(usex stk)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_STATIC_LIBRARY=$(usex test)
		-DBUILD_TCLCSOUND=$(usex tcl)
		-DBUILD_MULTI_CORE=$(usex threads)
		-DBUILD_UTILITIES=$(usex utils)
		-DBUILD_WEBSOCKET_OPCODE=$(usex websocket)
		-DNEED_PORTTIME=OFF
		-DBUILD_RELEASE=ON
		"${myconf[@]}"
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README.md Release_Notes/*

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
