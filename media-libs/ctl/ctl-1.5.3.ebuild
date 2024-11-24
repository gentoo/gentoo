# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="https://github.com/ampas/CTL"
SRC_URI="https://github.com/ampas/CTL/archive/${P}.tar.gz"
S="${WORKDIR}/CTL-${P}"

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

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/926823
	# https://github.com/ampas/CTL/issues/146
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DCTL_BUILD_TESTS=$(usex test)
		-DCTL_BUILD_TOOLS=ON
	)
	cmake_src_configure
}
