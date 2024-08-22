# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# As upstream (and we aswell) are not allowed to redistribute scansyn,
# we have to repackage the tarball. For that purpose use `bash files/repackage.sh version`
# Reference: https://github.com/csound/csound/issues/1148

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake flag-o-matic lua-single python-single-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/csound/csound.git"
	# vcpkg is not used anyway
	EGIT_SUBMODULES=()
	inherit git-r3
else
	DOC_P="Csound${PV}"
	SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/${P}-distributable.tar.xz
		doc? (
			https://github.com/csound/csound/releases/download/${PV}/${DOC_P}_manual_pdf.zip
			https://github.com/csound/csound/releases/download/${PV}/${DOC_P}_manual_html.zip
		)"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Sound design and signal processing system for composition and performance"
HOMEPAGE="https://csound.com/"

LICENSE="LGPL-2.1 doc? ( FDL-1.2+ )"
SLOT="0"
IUSE="+alsa beats curl +cxx debug doc double-precision dssi examples jack java lua nls osc portaudio
portaudio portmidi pulseaudio samples static-libs test +threads +utils vim-syntax"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	alsa? ( threads )
	java? ( cxx )
	lua? ( ${LUA_REQUIRED_USE} cxx )
"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	app-alternatives/yacc
	doc? ( media-libs/libpng )
	lua? ( dev-lang/swig )
	nls? ( sys-devel/gettext )
	test? (
		dev-util/cunit
		${PYTHON_DEPS}
	)
"
CDEPEND="
	dev-cpp/eigen:3
	media-libs/libsndfile
	media-libs/libsamplerate
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	dssi? (
		media-libs/dssi
		media-libs/ladspa-sdk
	)
	jack? ( virtual/jack )
	java? ( >=virtual/jdk-1.8:* )
	lua? ( ${LUA_DEPS} )
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-libs/libpulse )
	utils? ( !media-sound/snd )
	vim-syntax? ( !app-vim/csound-syntax )
"
RDEPEND="
	${CDEPEND}
	${PYTHON_DEPS}
"
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
)

pkg_setup() {
	use lua && lua-single_pkg_setup

	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -e '/set(PLUGIN_INSTALL_DIR/s/-${APIVERSION}//' \
		-e '/-O3/d' \
		-i CMakeLists.txt || die

	if use doc; then
		local png="${WORKDIR}/html/images/delayk.png"
		pngfix -q --out=${png/.png/fixed.png} ${png} # see pngfix help for exit codes
		[[ $? -gt 15 ]] && die "Failed to fix ${png}"
		mv -f ${png/.png/fixed.png} ${png} || die
	fi
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/860492
	# https://github.com/csound/csound/issues/1919
	filter-lto

	local mycmakeargs=(
		-DBUILD_BELA=OFF
		-DBUILD_CSBEATS=$(usex beats)
		-DBUILD_CXX_INTERFACE=$(usex cxx)
		-DBUILD_DEPRECATED_OPCODES=ON
		-DBUILD_DSSI_OPCODES=$(usex dssi)
		-DBUILD_INSTALLER=OFF
		-DBUILD_JAVA_INTERFACE=$(usex java)
		-DBUILD_LUA_INTERFACE=$(usex lua)
		-DBUILD_MULTI_CORE=$(usex threads)
		-DBUILD_OSC_OPCODES=$(usex osc)
		-DBUILD_PADSYNTH_OPCODES=ON
		-DBUILD_RELEASE=ON
		-DBUILD_SCANSYN_OPCODES=OFF # this is not allowed to be redistributed: https://github.com/csound/csound/issues/1148
		-DBUILD_STATIC_LIBRARY=$(usex static-libs "ON" $(usex test))
		-DBUILD_TESTS=$(usex test)
		-DBUILD_UTILITIES=$(usex utils)

		-DFAIL_MISSING=ON
		-DNEW_PARSER_DEBUG=$(usex debug)
		-DREQUIRE_PTHREADS=$(usex threads)

		-DUSE_ALSA=$(usex alsa)
		-DUSE_ATOMIC_BUILTIN=ON
		-DUSE_COMPILER_OPTIMIZATIONS=ON
		-DUSE_CURL=$(usex curl)
		-DUSE_DOUBLE=$(usex double-precision)
		-DUSE_GETTEXT=$(usex nls)
		-DUSE_GIT_COMMIT=ON
		-DUSE_IPMIDI=ON
		-DUSE_JACK=$(usex jack)
		-DUSE_LIB64=$([[ $(get_libdir) == "lib64" ]] && echo "ON" || echo "OFF")
		-DUSE_LRINT=ON
		-DUSE_PORTAUDIO=$(usex portaudio)
		-DUSE_PORTMIDI=$(usex portmidi)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DUSE_VCPKG=OFF
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

	python_optimize

	use java && (dosym lib_jcsound6.so usr/lib64/lib_jcsound.so.1 || die "Failed to create java lib symlink")

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
