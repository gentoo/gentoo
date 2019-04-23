# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Qt5 markdown editor"
HOMEPAGE="https://github.com/cloose/CuteMarkEd"
SRC_URI="https://github.com/cloose/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-text/discount
	app-text/hunspell
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qttest:5
	dev-qt/qtwebkit:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CuteMarkEd-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}"-0.11.1-respect-destdir.patch
	"${FILESDIR}/${PN}"-0.11.3-qaction-include.patch
	"${FILESDIR}/${PN}"-0.11.3-bgcolor.patch
)

src_configure() {
	eqmake5 ROOT="${D}" CuteMarkEd.pro
}
