# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Convergent RSS/Atom feed reader for Plasma"
HOMEPAGE="https://apps.kde.org/alligator/"

LICENSE="|| ( GPL-2 GPL-3 ) CC0-1.0 CC-BY-SA-4.0 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/kirigami-addons:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/syndication-${KFMIN}:6
"
RDEPEND="${DEPEND}"
