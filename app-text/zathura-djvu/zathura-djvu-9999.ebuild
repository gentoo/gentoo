# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://pwmt.org/projects/${PN}/download/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="DjVu plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND="
	app-text/djvu
	>=app-text/zathura-0.3.8
	dev-libs/glib:2
	x11-libs/cairo
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
