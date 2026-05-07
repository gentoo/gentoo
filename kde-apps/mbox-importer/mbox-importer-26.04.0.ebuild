# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Import mbox email archives from various sources into Akonadi"

LICENSE="GPL-2+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-apps/akonadi-${PVCUT}:6=
	>=kde-apps/kidentitymanagement-${PVCUT}:6=
	>=kde-apps/mailcommon-${PVCUT}:6=
	>=kde-apps/mailimporter-${PVCUT}:6=
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}"
