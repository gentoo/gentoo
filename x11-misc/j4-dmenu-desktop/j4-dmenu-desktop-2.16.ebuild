# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="A replacement for i3-dmenu-desktop"
HOMEPAGE="https://github.com/enkore/j4-dmenu-desktop"
SRC_URI="https://github.com/enkore/j4-dmenu-desktop/archive/r${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND="x11-misc/dmenu"

S="${WORKDIR}/${PN}-r${PV}"

src_configure() {
	cmake-utils_src_configure
}
