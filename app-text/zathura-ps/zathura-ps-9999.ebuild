# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/zathura-ps.git"
else
	KEYWORDS="~amd64 ~arm ~riscv ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="https://pwmt.org/projects/zathura-ps/download/${P}.tar.xz"
fi

DESCRIPTION="PostScript plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-ps/download/"

LICENSE="ZLIB"
SLOT="0"

# Tests currently only validating data files
RESTRICT="test"

DEPEND="app-text/libspectre
	>=app-text/zathura-0.3.9
	dev-libs/girara:=
	dev-libs/glib:2
	x11-libs/cairo"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
