# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://git.pwmt.org/pwmt/${PN}/-/archive/${PV}/${P}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="https://git.pwmt.org/pwmt/zathura-pdf-mupdf"

LICENSE="ZLIB"
SLOT="0"

DEPEND=">=app-text/mupdf-1.19:=
	>=app-text/zathura-0.3.9
	dev-libs/girara
	dev-libs/glib:2
	x11-libs/cairo"

RDEPEND="${DEPEND}"

BDEPEND="app-text/tesseract
	virtual/pkgconfig
	media-libs/leptonica
	dev-lang/mujs"

PATCHES=(
	"${FILESDIR}/zathura-pdf-mupdf-0.3.8-meson-mupdfthird.patch"
)
