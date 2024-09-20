# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( luajit )
LUA_REQ_USE="lua52compat"

WX_GTK_VER=3.2-gtk3
PLOCALES="ar be bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS sr_RS@latin uk_UA vi zh_CN zh_TW"

inherit autotools flag-o-matic lua-single plocale wxwidgets xdg-utils vcs-snapshot toolchain-funcs

DESCRIPTION="Advanced subtitle editor"
HOMEPAGE="http://www.aegisub.org/ https://github.com/wangqr/Aegisub"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/wangqr/${PN^}.git"
	# Submodules are used to pull bundled libraries.
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/wangqr/Aegisub/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa debug +fftw openal oss portaudio pulseaudio spell test +uchardet"
RESTRICT="test"

# aegisub bundles luabins (https://github.com/agladysh/luabins).
# Unfortunately, luabins upstream is practically dead since 2010.
# Thus unbundling luabins isn't worth the effort.
RDEPEND="${LUA_DEPS}
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,debug?]
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	media-libs/ffmpegsource:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libass:=[fontconfig]
	sys-libs/zlib
	virtual/libiconv
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	fftw? ( >=sci-libs/fftw-3.3:= )
	openal? ( media-libs/openal )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-libs/libpulse )
	spell? ( app-text/hunspell:= )
	uchardet? ( app-i18n/uchardet )
"
DEPEND="${RDEPEND}"
# luarocks is only used as a command-line tool so there is no need to enforce
# LUA_SINGLE_USEDEP on it. On the other hand, this means we must use version
# bounds in order to make sure we use a version migrated to Lua eclasses.
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		${RDEPEND}
		>=dev-cpp/gtest-1.8.1
		>=dev-lua/luarocks-3.4.0-r100
		$(lua_gen_cond_dep '
			dev-lua/busted[${LUA_USEDEP}]
		')
	)
"

REQUIRED_USE="${LUA_REQUIRED_USE}
	|| ( alsa openal oss portaudio pulseaudio )"

PATCHES=(
	"${FILESDIR}/3.2.2_p20160518/${PN}-3.2.2_p20160518-fix-system-luajit-build.patch"
	"${FILESDIR}/3.3.3/${PN}-3.3.3-support-system-gtest.patch"
	"${FILESDIR}/3.2.2_p20160518/${PN}-3.2.2_p20160518-tests_luarocks_lua_version.patch"
	"${FILESDIR}/3.2.2_p20160518/${PN}-3.2.2_p20160518-fix-boost-181-build.patch"
	"${FILESDIR}/3.3.3/${PN}-3.3.3-support-icu-75.patch"
)

aegisub_check_compiler() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++17; then
		die "Your compiler lacks C++17 support."
	fi
}

pkg_pretend() {
	aegisub_check_compiler
}

pkg_setup() {
	aegisub_check_compiler
	lua-single_pkg_setup
}

src_prepare() {
	default_src_prepare

	# Remove tests that require unavailable uuid Lua module.
	rm automation/tests/modules/lfs.moon || die

	remove_locale() {
		rm "po/${1}.po" || die
	}

	plocale_find_changes 'po' '' '.po'
	plocale_for_each_disabled_locale remove_locale

	# See http://devel.aegisub.org/ticket/1914
	config_rpath_update "${S}"/config.rpath

	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG
	# Prevent access violations from OpenAL detection. See Gentoo bug 508184.
	use openal && export agi_cv_with_openal="yes"

	setup-wxwidgets
	local myeconfargs=(
		--disable-update-checker
		--with-ffms2
		--with-system-luajit
		$(use_enable debug)
		$(use_with alsa)
		$(use_with fftw fftw3)
		$(use_with openal)
		$(use_with oss)
		$(use_with portaudio)
		$(use_with pulseaudio libpulse)
		$(use_with spell hunspell)
		$(use_with uchardet)
	)
	export FORCE_GIT_VERSION="v${PV}"
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake WITH_SYSTEM_GTEST=$(usex test)
}

src_test() {
	emake test-automation
	emake test-libaegisub
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
