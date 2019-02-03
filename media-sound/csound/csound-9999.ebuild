# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils java-pkg-opt-2 python-single-r1 toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/csound/csound.git"
	inherit git-r3
else
	DOC_P="Csound${PV}"
	SRC_URI="https://github.com/csound/csound/archive/${PV}.tar.gz -> ${P}.tar.gz
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
IUSE="+alsa beats chua csoundac curl +cxx debug doc double-precision dssi examples
fltk +fluidsynth +image jack java keyboard linear lua luajit nls osc portaudio
portaudio portmidi pulseaudio python samples static-libs stk test +threads +utils
vim-syntax websocket"

IUSE_LANGS=" de en_US es es_CO fr it ro ru"

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
	java? ( virtual/jdk:* )
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

if [[ ${PV} != "9999" ]]; then
	DEPEND+="doc? ( app-arch/unzip )"
fi

# requires specific alsa settings
RESTRICT="test"

pkg_setup() {
	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	sed -e '/set(PLUGIN_INSTALL_DIR/s/-${APIVERSION}//' \
		-e '/-O3/d' \
		-i CMakeLists.txt || die

	local lang
	for lang in ${IUSE_LANGS} ; do
		if ! has ${lang} ${LINGUAS-${lang}} ; then
			sed -i "/compile_po(${lang}/d" po/CMakeLists.txt || die
		fi
	done
}

src_configure() {
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
		-DUSE_PORTAUDIO=$(usex portaudio)
		-DUSE_PORTMIDI=$(usex portmidi)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DBUILD_PYTHON_OPCODES=$(usex python)
		-DBUILD_PYTHON_INTERFACE=$(usex python)
		-DBUILD_STATIC_LIBRARY=$(usex static-libs)
		-DBUILD_STK_OPCODES=$(usex stk)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_STATIC_LIBRARY=$(usex test)
		-DBUILD_MULTI_CORE=$(usex threads)
		-DBUILD_UTILITIES=$(usex utils)
		-DBUILD_WEBSOCKET_OPCODE=$(usex websocket)
		-DNEED_PORTTIME=OFF
		-DBUILD_RELEASE=ON
	)

	use python && mycmakeargs+=(
		-DPYTHON_MODULE_INSTALL_DIR="$(python_get_sitedir)"
	)

	[[ $(get_libdir) == "lib64" ]] && mycmakeargs+=(
		-DUSE_LIB64=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
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
	mv "${ED%/}"/usr/bin/{,csound_}extract || die

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
