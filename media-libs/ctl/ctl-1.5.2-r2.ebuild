# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="https://github.com/ampas/CTL"
SRC_URI="https://github.com/ampas/CTL/archive/${P}.tar.gz"
S="${WORKDIR}/CTL-ctl-${PV}"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="media-libs/ilmbase:=
	media-libs/openexr:0=
	media-libs/tiff:=
	!media-libs/openexr_ctl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-Use-GNUInstallDirs-and-fix-PkgConfig-files-1.patch"
	"${FILESDIR}/${P}-openexr-2.3.patch"
	"${FILESDIR}/${P}-fix-to-build-with-gcc-11.patch"
	"${FILESDIR}/${P}-install-dpx-library.patch"
	"${FILESDIR}/${P}-fix-unit-tests.patch"
)

mycmakeargs=( -DCMAKE_INSTALL_DOCDIR="share/doc/${PF}" )

src_test() {
	pushd ${BUILD_DIR} >/dev/null || die
	eninja check
	popd >/dev/null || die
}
