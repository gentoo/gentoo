# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_CATEGORY=utilities
KDE_RELEASE_SERVICE="true"
KFMIN=5.74.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Markdown viewer KParts plugin based on QTextDocument"
HOMEPAGE="https://apps.kde.org/en/markdownpart"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}"
