# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
LUA_REQ_USE="lua52compat"

WX_GTK_VER=3.2-gtk3
PLOCALES="ar be bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS sr_RS@latin tr uk_UA vi zh_CN zh_TW"

inherit meson flag-o-matic lua-single plocale wxwidgets xdg-utils vcs-snapshot toolchain-funcs

DESCRIPTION="Advanced subtitle editor"
HOMEPAGE="http://www.aegisub.org/ https://github.com/TypesettingTools/Aegisub"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/TypesettingTools/${PN^}.git"
	# Submodules are used to pull bundled libraries.
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/TypesettingTools/Aegisub/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi
LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa debug +fftw openal portaudio pulseaudio spell test +uchardet"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	|| ( alsa openal portaudio pulseaudio )"
RESTRICT="test"

# aegisub bundles luabins (https://github.com/agladysh/luabins).
# Unfortunately, luabins upstream is practically dead since 2010.
# Thus unbundling luabins isn't worth the effort.
RDEPEND="${LUA_DEPS}
	x11-libs/wxGTK:${WX_GTK_VER}=[X,opengl,debug?]
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
BDEPEND="
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

PATCHES=(
	"${FILESDIR}"/3.4.2/Fix-build-without-pch.patch
)

BUILD_DIR="${WORKDIR}/${P}-build"

aegisub_check_compiler() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++20; then
		die "Your compiler lacks C++20 support."
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
	        sed -i -e "s/^${1}\(@latin\)\?//g" po/LINGUAS || die
		rm "po/${1}.po" || die
	}

	plocale_find_changes 'po' '' '.po'
	plocale_for_each_disabled_locale remove_locale
	sed -i "s|#ifdef WITH_UPDATE_CHECKER| #if WITH_UPDATE_CHECKER == 1|g" "${S}"/src/dialog_version_check.cpp \
	                                                      "${S}"/src/command/app.cpp "${S}"/src/main.cpp || die
	use test || sed -i "s|subdir('tests')||g" "${S}"/meson.build || die

	mkdir "${BUILD_DIR}" || die
	cp "${FILESDIR}/${PV}"/git_version.h "${BUILD_DIR}"/git_version.h || die
}

src_configure() {
	tc-export PKG_CONFIG
	use debug && EMESON_BUILDTYPE=debug
	setup-wxwidgets
	local emesonargs=(
	        -Denable_update_checker=false
		-Dffms2=enabled
		-Dsystem_luajit=true
		$(meson_feature alsa)
		$(meson_feature fftw fftw3)
		$(meson_feature openal)
		$(meson_feature portaudio)
		$(meson_feature pulseaudio libpulse)
		$(meson_feature spell hunspell)
		$(meson_feature uchardet)
	)
	meson_src_configure
}

src_test() {
	meson_src_test test-libaegisub
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
