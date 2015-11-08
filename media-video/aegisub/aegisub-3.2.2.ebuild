# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PLOCALES="ar bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS@latin sr_RS uk_UA vi zh_CN zh_TW"
WX_GTK_VER="3.0"

inherit autotools-utils fdo-mime gnome2-utils l10n toolchain-funcs wxwidgets

DESCRIPTION="Advanced subtitle editor"
HOMEPAGE="http://www.aegisub.org/"
SRC_URI="http://ftp.aegisub.org/pub/releases/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug +ffmpeg +fftw openal oss portaudio pulseaudio spell"

# configure.ac specifies minimal versions for some of the dependencies below.
# However, most of these minimal versions date back to 2006-2010 yy.
# Such version specifiers are meaningless nowadays, so they are omitted.
RDEPEND="
	>=dev-lang/luajit-2.0.3:2=
	>=dev-libs/boost-1.50.0:=[icu,nls,threads]
	>=dev-libs/icu-4.8.1.1:=
	>=x11-libs/wxGTK-3.0.0:${WX_GTK_VER}[X,opengl,debug?]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libass[fontconfig]
	virtual/libiconv
	virtual/opengl

	alsa? ( media-libs/alsa-lib )
	openal? ( media-libs/openal )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-sound/pulseaudio )

	ffmpeg? ( >=media-libs/ffmpegsource-2.16:= )
	fftw? ( >=sci-libs/fftw-3.3:= )

	spell? ( app-text/hunspell )
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

# aegisub also bundles luabins (https://github.com/agladysh/luabins).
# Unfortunately, luabins upstream is dead since 2011.
# Thus unbundling luabins is not worth the effort.
PATCHES=(
	"${FILESDIR}/${P}-fix-lua-regexp.patch"
	"${FILESDIR}/${P}-unbundle-luajit.patch"
	"${FILESDIR}/${P}-respect-user-compiler-flags.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11; then
		die "Your compiler lacks C++11 support. Use GCC>=4.7.0 or Clang>=3.3."
	fi
}

src_prepare() {
	cp /usr/share/gettext/config.rpath . || die

	remove_locale() {
		rm "po/${1}.po" || die
	}

	l10n_find_plocales_changes 'po' '' '.po'
	l10n_for_each_disabled_locale_do remove_locale

	autotools-utils_src_prepare
}

src_configure() {
	# Prevent sandbox violation from OpenAL detection. Gentoo bug #508184.
	use openal && export agi_cv_with_openal="yes"
	local myeconfargs=(
		--disable-update-checker
		$(use_enable debug)
		$(use_with alsa)
		$(use_with ffmpeg ffms2)
		$(use_with fftw fftw3)
		$(use_with openal)
		$(use_with oss)
		$(use_with portaudio)
		$(use_with pulseaudio libpulse)
		$(use_with spell hunspell)
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
