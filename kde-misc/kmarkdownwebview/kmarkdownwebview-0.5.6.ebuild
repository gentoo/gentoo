# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ecm kde.org

DESCRIPTION="KPart for rendering Markdown content"
HOMEPAGE="https://apps.kde.org/en/kmarkdownwebviewpart"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="BSD LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kio:5
	kde-frameworks/kparts:5
	kde-frameworks/kxmlgui:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QTWEBKIT=OFF
	)
	ecm_src_configure
}
