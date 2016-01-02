# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Ignore rudimentary uz@Latn, zh_TW translation(s)
PLOCALES="cs_CZ cs de es_MX es fr gl hu it ja_JP lt pl_PL pl pt_BR pt_PT ro_RO ru sr tr uk zh_CN"

inherit cmake-utils fdo-mime gnome2-utils l10n

DESCRIPTION="Extracts audio tracks from an audio CD image to separate tracks"
HOMEPAGE="https://flacon.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="aac flac mac mp3 opus qt4 qt5 replaygain tta vorbis wavpack"

DEPEND="
	dev-libs/uchardet
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/linguist-tools:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}
	media-sound/shntool[mac?]
	aac? ( media-libs/faac )
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	mp3? ( media-sound/lame )
	opus? ( media-sound/opus-tools )
	replaygain? (
		mp3? ( media-sound/mp3gain )
		vorbis? ( media-sound/vorbisgain )
	)
	tta? ( media-sound/ttaenc )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )
"

REQUIRED_USE="^^ ( qt4 qt5 )"

PATCHES=(
	"${FILESDIR}/${P}-fix-qpainter-error.patch"
	"${FILESDIR}/${P}-fix-corrupt-file-crash.patch"
	"${FILESDIR}/${P}-fix-disks-or-tracks-number-change-crash.patch"
)

src_prepare() {
	# Ignore rudimentary uz@Latn, zh_TW translation(s)
	rm "translations/${PN}_uz@Latn.desktop" || die
	rm "translations/${PN}_zh_TW.ts" || die

	remove_locale() {
		rm "translations/${PN}_${1}."{ts,desktop} || die
	}

	l10n_find_plocales_changes 'translations' "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do remove_locale
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt4 QT4)
		$(cmake-utils_use_use qt5 QT5)
	)
	cmake-utils_src_configure
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
