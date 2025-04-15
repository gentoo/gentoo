# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY=graphics
KDE_ORG_NAME=kst-plot
KDE_ORG_COMMIT=16334f6f99613a1b60873d93835f9083dca258b2
inherit cmake flag-o-matic kde.org xdg

DESCRIPTION="Fast real-time large-dataset viewing and plotting tool"
HOMEPAGE="https://kst-plot.kde.org/"

LICENSE="GPL-2 LGPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RESTRICT="test"

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/tiff:=
	sci-libs/cfitsio:=
	sci-libs/getdata[cxx]
	sci-libs/gsl:=
	sci-libs/hdf5:=[cxx]
	sci-libs/matio:=
	sci-libs/netcdf-cxx:3
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS README.kstScript )

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.8-getdata-drop-bogus-lib_debug.patch # bug #593848
	"${FILESDIR}"/${P}-cmake{4,-findgsl}.patch # bug #884625; thx opensuse
	"${FILESDIR}"/${P}-hdf5cxx.patch # thx opensuse
)

src_prepare() {
	rm -r cmake/3rdparty || die

	cmake_src_prepare

	sed -e "/^kst_revision_project_name/ s/^/# removed by ebuild: /" \
		-i CMakeLists.txt || die
}

src_configure() {
	# -Werror=odr, -Werror=lto-type=-mismatch
	# https://bugs.gentoo.org/863296
	# https://bugs.kde.org/show_bug.cgi?id=484572
	filter-lto

	local mycmakeargs=(
		-Dkst_install_libdir="$(get_libdir)"
		-Dkst_revision=${PV/*_p/-}
		-Dkst_dbgsym=ON
		-Dkst_pch=OFF
		-Dkst_python=OFF
		-Dkst_qt5=ON
		-Dkst_qt4=OFF
		-Dkst_rpath=OFF
		-Dkst_svnversion=OFF
		-Dkst_verbose=ON
		-Dkst_release=$(usex debug OFF ON)
		-Dkst_test=$(usex test)
	)
	cmake_src_configure
}
