# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="false"
KFMIN=6.22.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Calendar support library"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 arm64"
IUSE=""

DEPEND="
	dev-libs/libical
	>=dev-libs/ktextaddons-1.8.0:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-apps/akonadi-${PVCUT}:6=
	>=kde-apps/akonadi-calendar-${PVCUT}:6=
	>=kde-apps/kcalutils-${PVCUT}:6=
	>=kde-apps/kidentitymanagement-${PVCUT}:6=
	>=kde-apps/kmime-${PVCUT}:6=
	>=kde-apps/libkdepim-${PVCUT}:6=
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}"
