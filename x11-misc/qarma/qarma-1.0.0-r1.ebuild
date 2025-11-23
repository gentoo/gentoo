# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Zenity Clone for Qt"
HOMEPAGE="https://github.com/luebking/qarma"
SRC_URI="https://github.com/luebking/qarma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-qt/qtbase:6[X,dbus,gui,widgets]"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake6
}

src_install() {
	dobin qarma
}
