# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_COMMIT=3fc4ae7a8af35d380654e573d895216fd5ba407e

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="https://github.com/ampas/CTL"
SRC_URI="https://github.com/ampas/CTL/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CTL-${MY_COMMIT}"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/imath:=
	>=media-libs/openexr-3:=[threads]
	media-libs/tiff:=
	!media-libs/openexr_ctl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.5.2-fix-installation-directories.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DCTL_BUILD_TESTS=$(usex test)
		-DCTL_BUILD_TOOLS=ON
	)
	cmake_src_configure
}
