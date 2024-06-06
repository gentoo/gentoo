# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.2.0
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Plugin based library to create window decorations"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}-727c116c.tar.gz"
S="${WORKDIR}/${PN}-727c116c197b9e0e569a9573484b88f4e967ddb6"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}"
