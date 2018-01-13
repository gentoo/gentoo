# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils flag-o-matic

DESCRIPTION="OpenEXR Viewers"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="cg"

RDEPEND="
	>=media-libs/ctl-1.5.2:=
	~media-libs/ilmbase-${PV}:=
	~media-libs/openexr-${PV}:=
	virtual/opengl
	x11-libs/fltk:1[opengl]
	cg? (
		media-gfx/nvidia-cg-toolkit
		|| (
			media-libs/freeglut
			media-libs/mesa[glut]
		)
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-add-missing-files.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package cg Cg)
		$(cmake-utils_use_find_package cg GLUT)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DILMBASE_PACKAGE_PREFIX="${EPREFIX}/usr"
		-DOPENEXR_PACKAGE_PREFIX="${EPREFIX}/usr"
	)

	use cg && append-flags "$(no-as-needed)" # binary-only libCg is not properly linked

	cmake-utils_src_configure
}
