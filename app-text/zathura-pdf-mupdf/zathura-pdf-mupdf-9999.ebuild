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

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND="
	>=app-text/zathura-2.0
	dev-libs/girara
	>=app-text/mupdf-1.14.0
	!app-text/zathura-pdf-poppler
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default

	sed -i '/mupdfthird/d' meson.build ||
		die 'fail to remove uninstallable mupdfthird'
}
