# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="QtPBFImagePlugin"
inherit qmake-utils

DESCRIPTION="Qt image plugin for displaying Mapbox vector tiles"
HOMEPAGE="https://github.com/tumic0/QtPBFImagePlugin/"
SRC_URI="https://github.com/tumic0/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl]
	sys-libs/zlib
"

src_configure() {
	eqmake6 pbfplugin.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
