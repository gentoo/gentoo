# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/pwmt/zathura-pdf-mupdf/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-pdf-mupdf/"

LICENSE="ZLIB"
SLOT="0"

DEPEND="app-text/mupdf
	>=app-text/zathura-0.3.9
	dev-libs/girara
	dev-libs/glib:2
	media-libs/jbig2dec:=
	media-libs/openjpeg:2=
	virtual/jpeg:0
	x11-libs/cairo"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	sed -i -e '/mupdfthird/d' meson.build || die "sed failed"
	default
}
