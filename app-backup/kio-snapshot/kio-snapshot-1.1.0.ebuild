# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="system"
KDE_TEST="forceoptional"
KFMIN=6.29.0
QTMIN=6.11.2
inherit ecm kde.org

DESCRIPTION="Btrfs Filesystem snapshot integration for KDE applications"
HOMEPAGE="https://invent.kde.org/system/kio-snapshot"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="CC-BY-SA-4.0 CC0-1.0 LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"

# Tests require root access to create a btrfs loop device to test against
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	sys-apps/util-linux
	sys-fs/btrfs-progs:=
"
RDEPEND="${DEPEND}"
# kcoreaddons: kcoreaddons_add_plugin
BDEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	virtual/pkgconfig
"
