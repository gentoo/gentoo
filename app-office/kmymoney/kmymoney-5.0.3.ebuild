# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="5.0"
PYTHON_COMPAT=( python2_7 )

KDE_GCC_MINIMAL="6.4"
KDE_HANDBOOK="optional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde5 python-single-r1

DESCRIPTION="Personal finance manager based on KDE Frameworks"
HOMEPAGE="https://kmymoney.org"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
fi

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="activities addressbook calendar hbci holidays ofx quotes webkit weboob"

REQUIRED_USE="weboob? ( ${PYTHON_REQUIRED_USE} )"

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
	>=app-office/libalkimia-6.0.0
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
	hbci? (
		>=net-libs/aqbanking-5.6.5
		>=sys-libs/gwenhywfar-4.15.3-r1[qt5]
	)
	holidays? ( $(add_frameworks_dep kholidays) )
	ofx? ( dev-libs/libofx )
	webkit? (
		$(add_frameworks_dep kdewebkit)
		$(add_qt_dep qtwebkit)
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
	virtual/pkgconfig
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
		-DENABLE_KBANKING=$(usex hbci)
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
	# bug: 652636
	local myctestargs=(
		-E "(reports-chart-test)"
	)

	kde5_src_test
}
