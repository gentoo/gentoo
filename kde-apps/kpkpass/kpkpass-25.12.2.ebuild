# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Library to deal with Apple Wallet pass files"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="LGPL-2.1+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=x11-misc/shared-mime-info-1.8
"
RDEPEND="${DEPEND}"
