# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/zathura-djvu.git"
else
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
	SRC_URI="https://pwmt.org/projects/zathura-djvu/download/${P}.tar.xz"
fi

DESCRIPTION="DjVu plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-djvu/"

LICENSE="ZLIB"
SLOT="0"

# Tests currently only validating data files
RESTRICT="test"

RDEPEND="app-text/djvu
	>=app-text/zathura-0.3.9
	dev-libs/girara:=
	dev-libs/glib:2
	x11-libs/cairo"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
	virtual/pkgconfig"
