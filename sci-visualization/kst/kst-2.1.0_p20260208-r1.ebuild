# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindHDF5 )
KDE_ORG_CATEGORY=graphics
KDE_ORG_NAME=kst-plot
KDE_ORG_COMMIT=e4dbcc472348100e040d464dd0cae52c337fafe6
inherit cmake flag-o-matic kde.org xdg

DESCRIPTION="Fast real-time large-dataset viewing and plotting tool"
HOMEPAGE="https://kst-plot.kde.org/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${KDE_ORG_NAME}-${PV}-${KDE_ORG_COMMIT:0:8}.tar.gz"

LICENSE="GPL-2 LGPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,widgets,xml]
	dev-qt/qtsvg:6
	dev-qt/qttools:6[designer]
	media-libs/tiff:=
	sci-libs/cfitsio:=
	sci-libs/getdata[cxx]
	sci-libs/gsl:=
	sci-libs/hdf5:=[cxx]
	sci-libs/matio:=
	sci-libs/netcdf-cxx:0=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( AUTHORS README.kstScript )

PATCHES=(
	"${FILESDIR}"/${P}-cmake-findhdf5.patch # bug #954233; downstream patch
)

src_prepare() {
	rm -r cmake/3rdparty pyKst || die
	cmake_src_prepare
}

src_configure() {
	# -Werror=odr, -Werror=lto-type=-mismatch
	# https://bugs.gentoo.org/863296
	# https://bugs.kde.org/show_bug.cgi?id=484572
	filter-lto
	cmake_src_configure
}
