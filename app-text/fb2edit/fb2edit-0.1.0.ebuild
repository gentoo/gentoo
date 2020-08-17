# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake
DESCRIPTION="Create and edit fb2 books"
HOMEPAGE="https://github.com/vitlav/fb2edit"
SRC_URI="https://github.com/vitlav/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtwebkit:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	dev-qt/linguist-tools:5
	dev-libs/libxml2:2"
BDEPEND="${RDEPEND}"
