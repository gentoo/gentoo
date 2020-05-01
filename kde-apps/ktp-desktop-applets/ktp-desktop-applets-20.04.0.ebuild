# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE Telepathy contact, presence and chat Plasma applets"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="|| ( GPL-2 GPL-3 ) GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND="
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
"
DEPEND="${RDEPEND}
	>=kde-frameworks/ki18n-${KFMIN}:5
"
