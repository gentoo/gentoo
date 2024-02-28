# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.249.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="QtQuick components providing basic image editing capabilities"
HOMEPAGE="https://invent.kde.org/libraries/kquickimageeditor
https://api.kde.org/kquickimageeditor/html/index.html"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="6"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=kde-frameworks/kirigami-${KFMIN}:6
"
