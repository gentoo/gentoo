# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="amd64 arm x86"
	SRC_URI="https://git.pwmt.org/pwmt/${PN}/-/archive/${PV}/${P}.tar.gz"
fi

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="https://git.pwmt.org/pwmt/zathura-pdf-mupdf"

LICENSE="ZLIB"
SLOT="0"
IUSE="+javascript"

DEPEND="
	>=app-text/mupdf-1.20.0:=[javascript?]
	>=app-text/zathura-0.5.2:=
	dev-libs/girara
	dev-libs/glib:2
	x11-libs/cairo
"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-meson-mupdfthird.patch"
)

src_prepare() (
	default

	if ! use javascript ; then
		sed -i -e '/mujs/d' meson.build || die
	fi
)
