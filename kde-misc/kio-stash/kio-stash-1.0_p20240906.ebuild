# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=2a8b88014643538a2fd8aad9e39f362d1fc91bf3
ECM_TEST="forceoptional"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="KIO worker and daemon to stash discontinuous file selections"
HOMEPAGE="https://arnavdhamija.com/2017/07/04/kio-stash-shipped/ https://invent.kde.org/utilities/kio-stash"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
"
RDEPEND="${DEPEND}"
