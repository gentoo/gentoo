# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="A tiny RSS and Atom feed reader"
HOMEPAGE="https://bitbucket.org/skunkos/rssguard"
SRC_URI="https://bitbucket.org/skunkos/rssguard/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt4 +qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
		dev-qt/qtxmlpatterns:4 )
	qt5? ( dev-qt/linguist-tools:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5 )"
RDEPEND="${DEPEND}"

DOCS=( README.md resources/text/CHANGELOG )

src_prepare() {
	sed -e '/Encoding/d' -i resources/desktop/${PN}.desktop.in || die 'sed failed'
	epatch_user
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt5 QT_5)
	)
	cmake-utils_src_configure
}
