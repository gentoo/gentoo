# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature qmake-utils xdg

DESCRIPTION="Image viewer and organizer"
HOMEPAGE="https://github.com/luebking/phototonic"
SRC_URI="https://github.com/luebking/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	media-gfx/exiv2:=
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake6
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "SVG image support" dev-qt/qtsvg:6
	optfeature "TIFF and TGA image support" dev-qt/qtimageformats:6
}
