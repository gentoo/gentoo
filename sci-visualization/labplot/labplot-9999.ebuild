# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.88.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Scientific data analysis and visualisation based on KDE Frameworks"
HOMEPAGE="https://labplot.kde.org/ https://apps.kde.org/labplot2/"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="cantor excel fftw fits hdf5 libcerf markdown matio netcdf origin root serial telemetry"

DEPEND="
	app-text/poppler
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	>=sci-libs/gsl-1.15:=
	cantor? (
		>=kde-apps/cantor-19.12.0:5
		>=kde-frameworks/kparts-${KFMIN}:5
		>=kde-frameworks/kservice-${KFMIN}:5
	)
	excel? ( dev-libs/qxlsx:= )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:= )
	hdf5? ( sci-libs/hdf5:= )
	libcerf? ( sci-libs/libcerf )
	markdown? ( app-text/discount:= )
	matio? ( sci-libs/matio:= )
	netcdf? ( sci-libs/netcdf:= )
	origin? ( sci-libs/liborigin:2 )
	root? (
		app-arch/lz4
		sys-libs/zlib
	)
	serial? ( >=dev-qt/qtserialport-${QTMIN}:5 )
	telemetry? ( kde-frameworks/kuserfeedback:5 )
"
RDEPEND="${DEPEND}"
# not packaged: dev-qt/qtmqtt, bug 683994
BDEPEND="
	app-alternatives/yacc
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_MQTT=OFF # not packaged
		-DENABLE_READSTAT=OFF # not packaged
		-DENABLE_VECTOR_BLF=OFF # not packaged
		-DENABLE_CANTOR=$(usex cantor)
		-DENABLE_EXCEL=$(usex excel)
		-DENABLE_FFTW=$(usex fftw)
		-DENABLE_FITS=$(usex fits)
		-DENABLE_HDF5=$(usex hdf5)
		-DENABLE_LIBCERF=$(usex libcerf)
		-DENABLE_DISCOUNT=$(usex markdown)
		-DENABLE_MATIO=$(usex matio)
		-DENABLE_NETCDF=$(usex netcdf)
		-DENABLE_LIBORIGIN=$(usex origin)
		-DENABLE_ROOT=$(usex root)
		-DENABLE_QTSERIALPORT=$(usex serial)
		$(cmake_use_find_package telemetry KUserFeedback)
		-DENABLE_TESTS=$(usex test)
	)

	ecm_src_configure
}
