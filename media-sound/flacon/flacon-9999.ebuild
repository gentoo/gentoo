# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/flacon/flacon-9999.ebuild,v 1.1 2014/04/26 17:54:13 maksbotan Exp $

EAPI="5"

PLOCALES="cs_CZ cs de es_MX es fr gl hu it pl_PL pl pt_BR pt_PT ro_RO ru si_LK uk zh_CN zh_TW"

EGIT_REPO_URI="https://github.com/flacon/flacon.git"

inherit cmake-utils l10n fdo-mime gnome2-utils
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="Extracts audio tracks from audio CD image to separate tracks"
HOMEPAGE="https://flacon.github.io/"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/flacon/flacon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="flac mac mp3 mp4 ogg replaygain tta wavpack"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-libs/uchardet
	media-sound/shntool[mac?]
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	mp3? ( media-sound/lame )
	mp4? ( media-libs/faac )
	ogg? ( media-sound/vorbis-tools )
	tta? ( media-sound/ttaenc )
	wavpack? ( media-sound/wavpack )
	replaygain? (
		mp3? ( media-sound/mp3gain )
		ogg? ( media-sound/vorbisgain )
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	my_rm_loc() {
		rm "translations/${PN}_${1}."{ts,desktop} || die
	}

	l10n_find_plocales_changes "translations" "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do my_rm_loc
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
