# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-djvu.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="amd64 arm ~riscv x86"
	SRC_URI="https://pwmt.org/projects/zathura-djvu/download/${P}.tar.xz"
fi

DESCRIPTION="DjVu plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-djvu/"

LICENSE="ZLIB"
SLOT="0"

RDEPEND="app-text/djvu
	>=app-text/zathura-0.3.9
	dev-libs/girara
	dev-libs/glib:2
	x11-libs/cairo"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
