# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

WX_GTK_VER=3.0
PLOCALES="ar bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS sr_RS@latin uk_UA vi zh_CN zh_TW"

inherit autotools fdo-mime flag-o-matic gnome2-utils l10n wxwidgets git-r3

DESCRIPTION="Advanced subtitle editor"
HOMEPAGE="http://www.aegisub.org/ https://github.com/Aegisub/Aegisub"
EGIT_REPO_URI="git://github.com/Aegisub/Aegisub.git"
# Submodules are used to pull bundled libraries.
EGIT_SUBMODULES=()

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug +fftw openal oss portaudio pulseaudio spell test +uchardet"

# aegisub bundles luabins (https://github.com/agladysh/luabins).
# Unfortunately, luabins upstream is practically dead since 2010.
# Thus unbundling luabins isn't worth the effort.
RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,debug?]
	dev-lang/luajit:2[lua52compat]
	dev-libs/boost:=[icu,nls,threads]
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
	pulseaudio? ( media-sound/pulseaudio )
	spell? ( app-text/hunspell )
	uchardet? ( dev-libs/uchardet )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	oss? ( virtual/os-headers )
	test? (
		~dev-cpp/gtest-1.7.0
		dev-lua/busted
		dev-lua/luarocks
	)
"

REQUIRED_USE="|| ( alsa openal oss portaudio pulseaudio )"

PATCHES=(
	"${FILESDIR}/3.2.2_p20160518/${PN}-3.2.2_p20160518-fix-system-luajit-build.patch"
	"${FILESDIR}/3.2.2_p20160518/${PN}-3.2.2_p20160518-respect-compiler-flags.patch"
	"${FILESDIR}/3.2.2_p20160518/${PN}-3.2.2_p20160518-support-system-gtest.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11; then
		die "Your compiler lacks C++11 support. Use GCC>=4.7.0 or Clang>=3.3."
	fi
}

src_prepare() {
	default_src_prepare

	# Remove tests that require unavailable uuid Lua module.
	rm automation/tests/modules/lfs.moon || die

	remove_locale() {
		rm "po/${1}.po" || die
	}

	l10n_find_plocales_changes 'po' '' '.po'
	l10n_for_each_disabled_locale_do remove_locale

	# See http://devel.aegisub.org/ticket/1914
	config_rpath_update "${S}"/config.rpath

	eautoreconf
}

src_configure() {
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
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake WITH_SYSTEM_GTEST=$(usex test)
}

src_test() {
	emake test-automation
	emake test-libaegisub
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
