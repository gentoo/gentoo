# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE color selector/editor"
HOMEPAGE="https://kde.org/applications/graphics/org.kde.kcolorchooser"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"
