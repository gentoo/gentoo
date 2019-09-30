# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_BRANCH="5.0"
PYTHON_COMPAT=( python2_7 )

KDE_HANDBOOK="optional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde5 python-single-r1

DESCRIPTION="Personal finance manager based on KDE Frameworks"
HOMEPAGE="https://kmymoney.org"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
IUSE="activities addressbook calendar holidays ofx quotes webkit weboob"

REQUIRED_USE="weboob? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="virtual/pkgconfig"
COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=app-crypt/gpgme-1.7.1-r1[cxx]
	>=app-office/libalkimia-7.0.0:=
	dev-libs/gmp:0=
	dev-libs/kdiagram:5
	dev-libs/libgpg-error
	activities? ( $(add_frameworks_dep kactivities) )
	addressbook? (
		$(add_kdeapps_dep akonadi)
		$(add_kdeapps_dep kcontacts)
		$(add_kdeapps_dep kidentitymanagement)
	)
	calendar? ( dev-libs/libical:= )
	holidays? ( $(add_frameworks_dep kholidays) )
	ofx? ( dev-libs/libofx )
	webkit? (
		$(add_frameworks_dep kdewebkit)
		>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	)
	!webkit? ( $(add_qt_dep qtwebengine 'widgets') )
	weboob? (
		${PYTHON_DEPS}
		$(add_qt_dep qtconcurrent)
		www-client/weboob[${PYTHON_USEDEP}]
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!app-office/kmymoney:4
	quotes? ( dev-perl/Finance-Quote )
"

pkg_setup() {
	use weboob && python_setup
	kde5_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_DESIGNER=OFF
		$(cmake-utils_use_find_package activities KF5Activities)
		$(cmake-utils_use_find_package addressbook KF5Akonadi)
		$(cmake-utils_use_find_package addressbook KF5Contacts)
		$(cmake-utils_use_find_package addressbook KF5IdentityManagement)
		-DENABLE_KBANKING=OFF
		-DENABLE_LIBICAL=$(usex calendar)
		$(cmake-utils_use_find_package holidays KF5Holidays)
		-DENABLE_OFXIMPORTER=$(usex ofx)
		-DENABLE_WEBENGINE=$(usex !webkit)
		-DENABLE_WEBOOB=$(usex weboob)
		$(cmake-utils_use_find_package weboob PythonLibs)
	)
	kde5_src_configure
}

src_test() {
	# bug 652636; bug 673052: needs kmymoney installed to succeed
	local myctestargs=(
		-E "(reports-chart-test|qsqlcipher-test)"
	)

	kde5_src_test
}
