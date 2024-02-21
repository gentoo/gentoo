# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.249.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.2
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma control module for SDDM"
HOMEPAGE="https://invent.kde.org/plasma/sddm-kcm"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-plasma/kde-cli-tools-${PVCUT}:*
	x11-misc/sddm
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

DOCS=( CONTRIBUTORS )
