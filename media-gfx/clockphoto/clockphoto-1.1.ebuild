# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="Adjusts photo timestamps based on clock photos."
HOMEPAGE="https://git.zx2c4.com/clockphoto/about/"
SRC_URI="https://git.zx2c4.com/clockphoto/snapshot/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtwidgets:5 dev-qt/qtgui:5 dev-qt/qtcore:5"
RDEPEND="media-gfx/exiv2 ${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin clockphoto
}
