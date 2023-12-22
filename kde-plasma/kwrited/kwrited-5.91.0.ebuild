# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.247.0
QTMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma daemon listening for wall and write messages"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpty-${KFMIN}:6
"
RDEPEND="${DEPEND}"
