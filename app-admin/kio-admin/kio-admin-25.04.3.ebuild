# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="system"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Manage files as administrator using the admin:// KIO protocol"
HOMEPAGE="https://invent.kde.org/system/kio-admin"

LICENSE="BSD CC0-1.0 FSFAP GPL-2 GPL-3"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=sys-auth/polkit-qt-0.175[qt6(+)]
"
RDEPEND="${DEPEND}"
