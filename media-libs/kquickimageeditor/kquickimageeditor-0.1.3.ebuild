# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.74.0
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="QtQuick components providing basic image editing capabilities"
HOMEPAGE="https://invent.kde.org/libraries/kquickimageeditor
https://api.kde.org/kquickimageeditor/html/index.html"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/$(ver_cut 1-2)/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="LGPL-2.1+"
SLOT="5"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:5
"
