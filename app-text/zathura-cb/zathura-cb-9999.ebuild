# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-cb.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
	SRC_URI="https://pwmt.org/projects/zathura-cb/download/${P}.tar.xz"
fi

DESCRIPTION="Comic book plug-in for zathura with 7zip, rar, tar and zip support"
HOMEPAGE="https://pwmt.org/projects/zathura-cb/"

LICENSE="ZLIB"
SLOT="0"

RDEPEND="app-arch/libarchive:=
	>=app-text/zathura-0.3.9
	dev-libs/girara
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2[jpeg]
	x11-libs/gtk+:3"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

BDEPEND="virtual/pkgconfig"
