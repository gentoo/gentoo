# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-pdf-poppler.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="amd64 arm ~arm64 ~riscv x86"
	SRC_URI="https://github.com/pwmt/zathura-pdf-poppler/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-pdf-poppler"

LICENSE="ZLIB"
SLOT="0"

# Tests currently only validating data files
RESTRICT="test"

DEPEND=">=app-text/poppler-21.12.0:=[cairo]
	>=app-text/zathura-0.5.3:=
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
