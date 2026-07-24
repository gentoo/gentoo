# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.27.0
QTMIN=6.10.1
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Kirigami addons and modules necessary to do a full featured KDE application"
HOMEPAGE="https://invent.kde.org/libraries/kirigami-app-components"

LICENSE="BSD CC0-1.0 FSFAP LGPL-2+ LGPL-2.1+"
SLOT="6"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
"
