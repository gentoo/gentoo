# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic

JUMBOV=20070520
DESCRIPTION="Interactive image manipulation program supporting a wide variety of formats"
HOMEPAGE="https://github.com/jasper-software/xv/"
SRC_URI="https://github.com/jasper-software/xv/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/xv-3.10a.png.bz2"

LICENSE="xv"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="jpeg tiff png webp"

DEPEND="
	x11-libs/libXt
	jpeg? ( media-libs/libjpeg-turbo:= )
	tiff? ( media-libs/tiff:= )
	png? (
		>=media-libs/libpng-1.2:=
		sys-libs/zlib
	)
	webp? ( media-libs/libwebp:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/xv-5.2.0-osx-bsd.patch"
)

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/859823
	# https://github.com/jasper-software/xv/issues/25
	filter-lto

	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DXV_ENABLE_JPEG=$(usex jpeg)
		-DXV_ENABLE_JP2K=OFF
		-DXV_ENABLE_PNG=$(usex png)
		-DXV_ENABLE_TIFF=$(usex tiff)
		-DXV_ENABLE_WEBP=$(usex webp)
		)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newicon "${WORKDIR}"/xv-3.10a.png ${PN}.png
	make_desktop_entry xv "" "" "Graphics;Viewer"
}
