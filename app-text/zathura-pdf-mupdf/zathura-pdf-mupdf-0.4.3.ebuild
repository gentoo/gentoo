# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/zathura-pdf-mupdf.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/pwmt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="PDF support for zathura using the mupdf PDF rendering library"
HOMEPAGE="https://pwmt.org/projects/zathura-pdf-mupdf/"

LICENSE="ZLIB"
SLOT="0"
IUSE="+javascript"

DEPEND="
	>=app-text/mupdf-1.24.0:=[javascript?]
	>=app-text/zathura-0.2.0:=
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
