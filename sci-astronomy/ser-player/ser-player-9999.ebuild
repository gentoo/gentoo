# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Video player for SER files used for solar, lunar and planetary astronomy-imaging"
HOMEPAGE="
	https://free-astro.org/index.php?title=SER_Player#Linux
	https://github.com/lock042/ser-player
"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lock042/ser-player.git"
else
	SRC_URI="https://github.com/lock042/ser-player/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	media-libs/libpng:=
"
RDEPEND="${DEPEND}"

src_compile() {
	eqmake6 \
		DEFINES+=DISABLE_NEW_VERSION_CHECK \
		CONFIG+=release
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
