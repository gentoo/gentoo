# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY=unmaintained
KDE_ORG_COMMIT=50ac0509891343bc01a0aeffda5a44a1e65d9d04
ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Tool for editing color palettes"
HOMEPAGE="https://userbase.kde.org/KColorEdit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-plasma/plasma-activities-${KFMIN}:5
"
RDEPEND="${DEPEND}
	!media-gfx/kcoloredit:4
"
