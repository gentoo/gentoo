# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Image viewer and organizer"
HOMEPAGE="https://github.com/luebking/phototonic"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/luebking/phototonic.git"
else
	SRC_URI="https://github.com/luebking/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="svg tiff"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	media-gfx/exiv2:=
	svg? ( dev-qt/qtsvg:6 )
	tiff? ( dev-qt/qtimageformats:6 )
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake6
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
