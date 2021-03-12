# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# As upstream (and we aswell) are not allowed to redistribute scansyn,
# we have to repackage the tarball. For that purpose use `bash files/repackage.sh version`
# Reference: https://github.com/csound/csound/issues/1148

EAPI=7

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake lua-single python-single-r1 toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/csound/csound.git"
	inherit git-r3
else
	DOC_P="Csound${PV}"
	SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/${P}-distributable.tar.xz
		doc? (
			https://github.com/csound/csound/releases/download/${PV}/${DOC_P}_manual_pdf.zip
			https://github.com/csound/csound/releases/download/${PV}/${DOC_P}_manual_html.zip
		)"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Sound design and signal processing system for composition and performance"
HOMEPAGE="https://csound.github.io/"

LICENSE="LGPL-2.1 doc? ( FDL-1.2+ )"
SLOT="0"
IUSE="+alsa beats chua curl +cxx debug doc double-precision dssi examples
fltk +fluidsynth hdf5 +image jack java keyboard linear lua mp3 nls osc portaudio
portaudio portmidi pulseaudio python samples static-libs stk test +threads +utils
vim-syntax websocket"

REQUIRED_USE="
	alsa? ( threads )
	java? ( cxx )
	linear? ( double-precision )
	lua? ( ${LUA_REQUIRED_USE} cxx )
	python? ( ${PYTHON_REQUIRED_USE} cxx )
"

BDEPEND="
	sys-devel/flex
	virtual/yacc
	chua? ( dev-libs/boost )
	lua? ( dev-lang/swig )
	python? ( dev-lang/swig )
	nls? ( sys-devel/gettext )
	test? (
		dev-util/cunit
		${PYTHON_DEPS}
	)
"
# linear currently works only with sci-mathematics-gmm-5.1
#   https://github.com/csound/csound/issues/920
CDEPEND="
	dev-cpp/eigen:3
	>=media-libs/libsndfile-1.0.16
	media-libs/libsamplerate
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	dssi? (
		media-libs/dssi
		media-libs/ladspa-sdk
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	fltk? ( x11-libs/fltk:1[threads?] )
	hdf5? ( sci-libs/hdf5 )
	image? ( media-libs/libpng:0= )
	jack? ( virtual/jack )
	java? ( >=virtual/jdk-1.8:* )
	keyboard? ( x11-libs/fltk:1[threads?] )
	linear? ( =sci-mathematics/gmm-5.1* )
	lua? ( ${LUA_DEPS} )
	mp3? ( >=media-sound/lame-3.100-r3 )
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	python? ( ${PYTHON_DEPS} )
	stk? ( media-libs/stk )
	utils? ( !media-sound/snd )
	websocket? ( net-libs/libwebsockets:= )
"
RDEPEND="${CDEPEND}"
DEPEND="
	${CDEPEND}
	dev-libs/boost
"

if [[ ${PV} != "9999" ]]; then
	DEPEND+="doc? ( app-arch/unzip )"
fi

# requires specific alsa settings
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-6.13.0-xdg-open.patch"
	"${FILESDIR}/${PN}-6.15.0-lame.patch"
)

pkg_setup() {
	use lua && lua-single_pkg_setup

	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	cmake_src_prepare

	sed -e '/set(PLUGIN_INSTALL_DIR/s/-${APIVERSION}//' \
		-e '/-O3/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_BELA=OFF
		-DBUILD_BUCHLA_OPCODES=ON
		-DBUILD_CHUA_OPCODES=$(usex chua)
		-DBUILD_COUNTER_OPCODES=ON
		-DBUILD_CSBEATS=$(usex beats)
		-DBUILD_CUDA_OPCODES=OFF
		-DBUILD_CXX_INTERFACE=$(usex cxx)
		-DBUILD_DSSI_OPCODES=$(usex dssi)
		-DBUILD_EMUGENS_OPCODES=ON
		-DBUILD_EXCITER_OPCODES=ON
		-DBUILD_FAUST_OPCODES=OFF
		-DBUILD_FLUID_OPCODES=$(usex fluidsynth)
		-DBUILD_FRAMEBUFFER_OPCODES=ON
		-DBUILD_HDF5_OPCODES=$(usex hdf5)
		-DBUILD_IMAGE_OPCODES=$(usex image)
		-DBUILD_INSTALLER=OFF
		-DBUILD_JACK_OPCODES=$(usex jack)
		-DBUILD_JAVA_INTERFACE=$(usex java)
		-DBUILD_LINEAR_ALGEBRA_OPCODES=$(usex linear)
		-DBUILD_LUA_INTERFACE=$(usex lua)
		-DBUILD_MP3OUT_OPCODE=$(usex mp3)
		-DBUILD_MULTI_CORE=$(usex threads)
		-DBUILD_OPENCL_OPCODES=OFF
		-DBUILD_OSC_OPCODES=$(usex osc)
		-DBUILD_P5GLOVE_OPCODES=OFF
		-DBUILD_PADSYNTH_OPCODES=ON
		-DBUILD_PLATEREV_OPCODES=ON
		-DBUILD_PVSGENDY_OPCODE=OFF
		-DBUILD_PYTHON_INTERFACE=$(usex python)
		-DBUILD_PYTHON_OPCODES=$(usex python)
		-DBUILD_RELEASE=ON
		-DBUILD_SCANSYN_OPCODES=OFF # this is not allowed to be redistributed: https://github.com/csound/csound/issues/1148
		-DBUILD_SELECT_OPCODE=ON
		-DBUILD_SERIAL_OPCODES=ON
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STACK_OPCODES=ON
		-DBUILD_STATIC_LIBRARY=$(usex static-libs "ON" $(usex test))
		-DBUILD_STK_OPCODES=$(usex stk)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_UTILITIES=$(usex utils)
		-DBUILD_VIRTUAL_KEYBOARD=$(usex keyboard)
		-DBUILD_VST4CS_OPCODES=OFF
		-DBUILD_WEBSOCKET_OPCODE=$(usex websocket)
		-DBUILD_WIIMOTE_OPCODES=OFF
		-DBUILD_WINSOUND=OFF

		-DFAIL_MISSING=ON
		-DNEW_PARSER_DEBUG=$(usex debug)
		-DREQUIRE_PTHREADS=$(usex threads)

		-DUSE_ALSA=$(usex alsa)
		-DUSE_ATOMIC_BUILTIN=ON
		-DUSE_AUDIOUNIT=OFF # Apple specific
		-DUSE_COMPILER_OPTIMIZATIONS=ON
		-DUSE_COREMIDI=OFF # Apple specific
		-DUSE_CURL=$(usex curl)
		-DUSE_DOUBLE=$(usex double-precision)
		-DUSE_FLTK=$(usex fltk)
		-DUSE_GETTEXT=$(usex nls)
		-DUSE_GIT_COMMIT=ON
		-DUSE_IPMIDI=ON
		-DUSE_JACK=$(usex jack)
		-DUSE_LIB64=$([[ $(get_libdir) == "lib64" ]] && echo "ON" || echo "OFF")
		-DUSE_LRINT=ON
		-DUSE_PORTAUDIO=$(usex portaudio)
		-DUSE_PORTMIDI=$(usex portmidi)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)

	)

	use java && mycmakeargs+=(
		-DJAVA_HOME="$(java-config -g JAVA_HOME)"
	)

	use lua && mycmakeargs+=(
		-DLUA_H_PATH="$(lua_get_include_dir)"
		-DLUA_LIBRARY="$(lua_get_shared_lib)"
		# LUA_MODULE_INSTALL_DIR omitted on purpose, csound Lua module links against liblua
		# so it must NOT be installed into cmod_dir.
	)

	use python && mycmakeargs+=(
		-DPYTHON_MODULE_INSTALL_DIR="$(python_get_sitedir)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc -r Release_Notes/.

	# generate env.d file
	cat > "${T}"/62${PN} <<-_EOF_ || die
		OPCODEDIR$(usex double-precision 64 '')="${EPREFIX}/usr/$(get_libdir)/${PN}/plugins$(usex double-precision 64 '')"
		CSSTRNGS="${EPREFIX}/usr/share/locale"
	_EOF_
	if use stk ; then
		echo RAWWAVE_PATH=\"${EPREFIX}/usr/share/csound/rawwaves\" >> "${T}"/62${PN} || die
	fi
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
	mv "${ED}"/usr/bin/{,csound_}extract || die

	use python && python_optimize

	# install docs
	if [[ ${PV} != "9999" ]] && use doc ; then
		dodoc "${WORKDIR}"/*.pdf
		dodoc -r "${WORKDIR}"/html
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		elog "The extract tool is now installed as csound_extract"
		elog "due to collisions with many other packages (bug #247394)."
		elog
	fi
}
