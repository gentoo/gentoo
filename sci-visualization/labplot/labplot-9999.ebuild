# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Scientific data analysis and visualisation based on KDE Frameworks"
HOMEPAGE="https://labplot.kde.org/ https://apps.kde.org/labplot2/"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="eigen excel fftw fits hdf5 libcerf markdown matio netcdf ods origin root serial share telemetry"

# IUSE="cantor"
# 	cantor? (
# 		>=kde-apps/cantor-19.12.0:6
# 		>=kde-frameworks/kparts-${KFMIN}:6
# 		>=kde-frameworks/kservice-${KFMIN}:6
# 	)
DEPEND="
	app-text/poppler[qt6(-)]
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,gui,network,sql,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	>=sci-libs/gsl-1.15:=
	eigen? ( dev-cpp/eigen:3= )
	excel? ( dev-libs/qxlsx:= )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:= )
	hdf5? ( sci-libs/hdf5:= )
	libcerf? ( sci-libs/libcerf )
	markdown? ( app-text/discount:= )
	matio? ( sci-libs/matio:= )
	netcdf? ( sci-libs/netcdf:= )
	ods? (
		dev-libs/libixion:=
		dev-libs/liborcus:=
	)
	origin? ( sci-libs/liborigin:2 )
	root? (
		app-arch/lz4
		sys-libs/zlib
	)
	serial? ( >=dev-qt/qtserialport-${QTMIN}:6 )
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
	telemetry? ( >=kde-frameworks/kuserfeedback-${KFMIN}:6 )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
# not packaged: dev-qt/qtmqtt, bug 683994
BDEPEND="
	app-alternatives/yacc
	sys-devel/gettext
"

src_prepare() {
	ecm_src_prepare

	sed -e "/^ *find_package.*QT NAMES/s/Qt5 //" \
		-i CMakeLists.txt || die # ensure Qt6 build
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_MQTT=OFF # not packaged
		-DENABLE_READSTAT=OFF # not packaged
		-DENABLE_VECTOR_BLF=OFF # not packaged
		-DENABLE_CANTOR=OFF # $(usex cantor)
		-DENABLE_EIGEN3=$(usex eigen)
		-DENABLE_XLSX=$(usex excel)
		-DENABLE_FFTW=$(usex fftw)
		-DENABLE_FITS=$(usex fits)
		-DENABLE_HDF5=$(usex hdf5)
		-DENABLE_LIBCERF=$(usex libcerf)
		-DENABLE_DISCOUNT=$(usex markdown)
		-DENABLE_MATIO=$(usex matio)
		-DENABLE_NETCDF=$(usex netcdf)
		-DENABLE_ORCUS=$(usex ods)
		-DENABLE_LIBORIGIN=$(usex origin)
		$(cmake_use_find_package share KF6Purpose)
		-DENABLE_ROOT=$(usex root)
		-DENABLE_QTSERIALPORT=$(usex serial)
		$(cmake_use_find_package telemetry KUserFeedbackQt6) # FIXME: should be KF6UserFeedback
		-DENABLE_TESTS=$(usex test)
	)

	ecm_src_configure
}
