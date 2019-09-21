# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="bg cs da de en_GB en es eu fr gl he_IL hr hu it ja ko ms nn_NO pl pt_BR pt ru sq sr tr uk zh_CN zh_TW"
PLOCALE_BACKUP="en"
inherit desktop l10n qmake-utils

DESCRIPTION="YouTube Browser for SMPlayer"
HOMEPAGE="http://smplayer.sourceforge.net/smtube"
SRC_URI="mirror://sourceforge/smtube/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtscript:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	|| (
		media-video/smplayer
		media-video/mpv
		media-video/mplayer
		media-video/vlc
		media-video/totem
	)
"

gen_translation() {
	"$(qt5_get_bindir)"/lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_compile() {
	eqmake5 src/${PN}.pro
	emake

	cd src/translations || die
	l10n_for_each_locale_do gen_translation
}

install_locale() {
	insinto /usr/share/${PN}/translations
	doins src/translations/${PN}_${1}.qm
	eend $? || die "failed to install $1 translation"
}

src_install() {
	dobin ${PN}
	domenu ${PN}.desktop
	newicon icons/${PN}_64.png ${PN}.png
	dodoc Changelog

	l10n_for_each_locale_do install_locale
}
