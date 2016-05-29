# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PLOCALES="ar bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS@latin sr_RS uk_UA vi zh_CN zh_TW"
WX_GTK_VER="3.0"

inherit autotools-utils fdo-mime flag-o-matic gnome2-utils l10n wxwidgets git-r3

DESCRIPTION="Advanced subtitle editor"
HOMEPAGE="http://www.aegisub.org/"
EGIT_REPO_URI="git://github.com/Aegisub/Aegisub.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug +ffmpeg +fftw openal oss portaudio pulseaudio spell +uchardet"

# configure.ac specifies minimal versions for some of the dependencies below.
# However, most of these minimal versions date back to 2006-2012 yy.
# Such version specifiers are meaningless nowadays, so they are omitted.
#
# aegisub bundles luabins (https://github.com/agladysh/luabins).
# Unfortunately, luabins upstream is practically dead since 2010.
# Thus unbundling luabins is not worth the effort.
RDEPEND="
	dev-lang/luajit:2[lua52compat]
	dev-libs/boost:=[icu,nls,threads]
	dev-libs/icu:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libass:=[fontconfig]
	virtual/libiconv
	virtual/opengl
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,debug?]

	alsa? ( media-libs/alsa-lib )
	openal? ( media-libs/openal )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-sound/pulseaudio )

	ffmpeg? ( media-libs/ffmpegsource:= )
	fftw? ( >=sci-libs/fftw-3.3:= )

	spell? ( app-text/hunspell )
	uchardet? ( dev-libs/uchardet )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
REQUIRED_USE="
	|| ( alsa openal oss portaudio pulseaudio )
"

# submodules are used to pull in bundled libraries
EGIT_SUBMODULES=()

PATCHES=(
	"${FILESDIR}/${PN}-3.2.2_p20160306-fix-luajit-unbundling.patch"
	"${FILESDIR}/${PN}-3.2.2_p20160306-respect-user-compiler-flags.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11; then
		die "Your compiler lacks C++11 support. Use GCC>=4.7.0 or Clang>=3.3."
	fi
}

src_prepare() {
	remove_locale() {
		rm "po/${1}.po" || die
	}

	l10n_find_plocales_changes 'po' '' '.po'
	l10n_for_each_disabled_locale_do remove_locale

	# See http://devel.aegisub.org/ticket/1914
	config_rpath_update "${S}/config.rpath"

	autotools-utils_src_prepare
}

src_configure() {
	# Prevent sandbox violation from OpenAL detection. Gentoo bug #508184.
	use openal && export agi_cv_with_openal="yes"
	local myeconfargs=(
		--disable-update-checker
		--with-system-luajit
		$(use_enable debug)
		$(use_with alsa)
		$(use_with ffmpeg ffms2)
		$(use_with fftw fftw3)
		$(use_with openal)
		$(use_with oss)
		$(use_with portaudio)
		$(use_with pulseaudio libpulse)
		$(use_with spell hunspell)
		$(use_with uchardet)
	)
	autotools-utils_src_configure
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
