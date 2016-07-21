# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLOCALES="bg cs da de en_GB en es eu fr gl he_IL hr hu it ja ko ms nn_NO pl pt_BR pt ru sq sr tr uk zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit l10n qt4-r2

DESCRIPTION="YouTube Browser for SMPlayer"
HOMEPAGE="http://smplayer.sourceforge.net/smtube"
SRC_URI="mirror://sourceforge/smplayer/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
SLOT="0"
IUSE="qt5"

# Deps in makefile seemed to be -core, -network, -script, -gui, -webkit, but the
# given packages seem to be deprecated...
DEPEND="qt5? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwebkit:5 )
		!qt5? ( dev-qt/qtcore:4 dev-qt/qtgui:4 dev-qt/qtwebkit:4 )"
RDEPEND="${DEPEND}
	|| ( media-video/smplayer[streaming] media-video/mpv media-video/mplayer media-video/vlc media-video/totem media-video/gnome-mplayer )"

src_prepare() {
	eqmake4 src/${PN}.pro
}

gen_translation() {
	lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_compile() {
	emake

	cd "${S}"/src/translations
	l10n_for_each_locale_do gen_translation
}

install_locale() {
	insinto /usr/share/${PN}/translations
	doins "${S}"/src/translations/${PN}_${1}.qm
	eend $? || die "failed to install $1 translation"
}

src_install() {
	dobin ${PN}
	domenu ${PN}.desktop
	newicon icons/${PN}_64.png ${PN}.png
	dodoc Changelog

	l10n_for_each_locale_do install_locale
}
