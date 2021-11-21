# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="https://github.com/ampas/CTL"
SRC_URI="https://github.com/ampas/CTL/archive/${P}.tar.gz"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc64 x86"

RDEPEND="media-libs/ilmbase:=
	media-libs/openexr:=
	media-libs/tiff:=
	!media-libs/openexr_ctl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/CTL-ctl-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-Use-GNUInstallDirs-and-fix-PkgConfig-files-1.patch"
	"${FILESDIR}/${P}-openexr-2.3.patch"
)

mycmakeargs=( -DCMAKE_INSTALL_DOCDIR="share/doc/${PF}" )
