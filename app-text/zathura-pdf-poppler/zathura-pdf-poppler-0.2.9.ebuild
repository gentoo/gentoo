# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-pdf-poppler.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.xz"
fi

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-pdf-poppler"

LICENSE="ZLIB"
SLOT="0"

DEPEND="app-text/poppler[cairo]
	>=app-text/zathura-0.3.9
	dev-libs/girara
	dev-libs/glib:2"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
