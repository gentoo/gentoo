# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.2
inherit ecm plasma.kde.org

DESCRIPTION="Flatpak Permissions Management KCM"
HOMEPAGE="https://invent.kde.org/plasma/flatpak-kcm"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=sys-apps/flatpak-0.11.8
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"
