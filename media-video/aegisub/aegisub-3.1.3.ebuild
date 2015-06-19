# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/aegisub/aegisub-3.1.3.ebuild,v 1.2 2014/07/18 08:50:30 maksbotan Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
WX_GTK_VER="3.0"
PLOCALES="ar bg ca cs da de el es eu fa fi fr_FR gl hu id it ja ko nl pl pt_BR pt_PT ru sr_RS@latin sr_RS vi zh_CN zh_TW"
inherit autotools-utils wxwidgets l10n fdo-mime gnome2-utils

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://www.aegisub.org/"
SRC_URI="http://ftp.aegisub.org/pub/releases/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug +ffmpeg +fftw openal oss portaudio pulseaudio spell"

REQUIRED_USE="
	|| ( alsa openal oss portaudio pulseaudio )
"

RDEPEND="
	>=x11-libs/wxGTK-3.0.0:${WX_GTK_VER}[X,opengl,debug?]
	virtual/opengl
	virtual/glu
	>=media-libs/libass-0.10.0[fontconfig]
	virtual/libiconv
	>=dev-libs/boost-1.53.0:=[icu,nls,threads]
	>=dev-libs/icu-4.8.1.1:=
	>=media-libs/fontconfig-2.4.2
	>=media-libs/freetype-2.3.5:2

	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.5 )
	openal? ( media-libs/openal )

	spell? ( >=app-text/hunspell-1.2.2 )
	ffmpeg? ( >=media-libs/ffmpegsource-2.17:= )
	fftw? ( >=sci-libs/fftw-3.3 )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
	>=sys-devel/gettext-0.18
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:${1}\.po::" po/Makefile || die
		rm "po/${1}.po" || die
	}

	l10n_find_plocales_changes 'po' '' '.po'
	if [ -z "$(l10n_get_locales)" ]; then
		sed -e 's/^\s*po\s*$//' -i Makefile || die
	else
		l10n_for_each_disabled_locale_do my_rm_loc
	fi

	autotools-utils_src_prepare
}

src_configure() {
	# testing openal does not work in sandbox, bug #508184
	use openal && export agi_cv_with_openal="yes"
	local myeconfargs=(
		$(use_with alsa)
		$(use_with oss)
		$(use_with portaudio)
		$(use_with pulseaudio libpulse)
		$(use_with openal)
		$(use_with ffmpeg ffms2)
		$(use_with fftw fftw3)
		$(use_with spell hunspell)
		$(use_enable debug)
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
