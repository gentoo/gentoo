# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KDE_ORG_CATEGORY="utilities"
KFMIN=6.27.0
QTMIN=6.11.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Password manager GUI for SecretService providers"
HOMEPAGE="https://apps.kde.org/keepsecret/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	app-crypt/libsecret
	dev-libs/kirigami-app-components:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
"
RDEPEND="${DEPEND}
	dev-libs/kirigami-addons:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
"
