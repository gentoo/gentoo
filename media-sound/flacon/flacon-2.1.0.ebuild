# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Ignore rudimentary et, uz@Latn, zh_TW translation(s).
PLOCALES="cs cs_CZ de es es_MX fr gl hu it ja_JP lt nb nl pl pl_PL pt_BR pt_PT ro_RO ru sr sr@latin tr uk zh_CN"

inherit cmake-utils eutils gnome2-utils l10n virtualx xdg-utils

DESCRIPTION="Extracts audio tracks from an audio CD image to separate tracks"
HOMEPAGE="https://flacon.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5 test"

COMMON_DEPEND="
	dev-libs/uchardet
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${COMMON_DEPEND}
	media-sound/shntool
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
	test? (
		media-sound/shntool
		virtual/ffmpeg
		!qt5? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

src_prepare() {
	cmake-utils_src_prepare

	# Ignore rudimentary et, uz@Latn, zh_TW translation(s).
	rm "translations/${PN}_uz@Latn.desktop" || die
	rm "translations/${PN}"_{et,zh_TW}.ts || die

	remove_locale() {
		rm "translations/${PN}_${1}".{ts,desktop} || die
	}

	l10n_find_plocales_changes 'translations' "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do remove_locale
}

src_configure() {
	local mycmakeargs=(
		-DUSE_QT4="$(usex !qt5)"
		-DUSE_QT5="$(usex qt5)"
		-DTEST_DATA_DIR="${S}/tests/data/"
		-DBUILD_TESTS="$(usex test 'Yes')"
	)
	cmake-utils_src_configure
}

src_test() {
	virtx "${BUILD_DIR}/tests/${PN}_test"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "${PN} optionally supports formats listed below."
	elog "(List will be empty if all extra packages are installed.)"
	elog "Please install the required packages and restart ${PN}."
	optfeature 'FLAC input and output support' media-libs/flac
	optfeature 'WavPack input and output support' media-sound/wavpack
	optfeature 'APE input support' media-sound/mac
	optfeature 'TTA input support' media-sound/ttaenc
	optfeature 'AAC output support' media-libs/faac
	optfeature 'MP3 output support' media-sound/lame
	optfeature 'Vorbis output support' media-sound/vorbis-tools
	optfeature 'MP3 Replay Gain support' media-sound/mp3gain
	optfeature 'Vorbis Replay Gain support' media-sound/vorbisgain

	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
