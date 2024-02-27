# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="5.1"
ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit ecm kde.org optfeature

DESCRIPTION="Personal finance manager based on KDE Frameworks"
HOMEPAGE="https://kmymoney.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="activities addressbook calendar hbci holidays"
[[ ${KDE_BUILD_TYPE} = live ]] && IUSE+=" experimental"

RDEPEND="
	>=app-crypt/gpgme-1.7.1-r1:=[cxx]
	>=app-office/libalkimia-7.0.0:=
	dev-db/sqlcipher
	dev-libs/gmp:0=[cxx(+)]
	dev-libs/kdiagram:5
	dev-libs/libgpg-error
	dev-libs/libofx:=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:5 )
	addressbook? (
		kde-apps/akonadi:5
		kde-apps/kidentitymanagement:5
		>=kde-frameworks/kcontacts-${KFMIN}:5
	)
	calendar? ( dev-libs/libical:= )
	hbci? (
		>=dev-qt/qtdeclarative-${QTMIN}:5
		>=net-libs/aqbanking-6.0.1
		>=sys-libs/gwenhywfar-5.1.2:=[qt5]
	)
	holidays? ( >=kde-frameworks/kholidays-${KFMIN}:5 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

pkg_setup() {
	ecm_pkg_setup

	if [[ ${KDE_BUILD_TYPE} = live ]] && use experimental; then
		ewarn "USE experimental set: Building unfinished features."
		ewarn "This *will* chew up your data. You have been warned."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_OFXIMPORTER=ON
		-DENABLE_WEBENGINE=ON
		-DENABLE_WOOB=OFF # ported to Py3; not yet re-added in Gentoo
		-DUSE_QT_DESIGNER=OFF
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package addressbook KF5Akonadi)
		$(cmake_use_find_package addressbook KF5Contacts)
		$(cmake_use_find_package addressbook KF5IdentityManagement)
		-DENABLE_LIBICAL=$(usex calendar)
		-DENABLE_KBANKING=$(usex hbci)
		$(cmake_use_find_package holidays KF5Holidays)
	)
	[[ ${KDE_BUILD_TYPE} = live ]] &&
		mycmakeargs+=( -DENABLE_UNFINISHEDFEATURES=$(usex experimental) )

	ecm_src_configure
}

src_test() {
	# bug 652636; bug 673052: needs kmymoney installed to succeed
	local myctestargs=(
		-E "(reports-chart-test|qsqlcipher-test)"
	)

	ecm_src_test
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "more options for online stock quote retrieval" dev-perl/Finance-Quote
	fi
	if has_version "app-office/kmymoney[quotes]"; then
		elog "Please note: IUSE=quotes flag is gone in ${PN}-5.1.1. ${PN} still"
		elog "does online stock quote retrieval without it, but dev-perl/Finance-Quote"
		elog "may provide additional sources. To keep the functionality, run:"
		elog "  emerge --noreplace dev-perl/Finance-Quote"
	fi
	ecm_pkg_postinst
}
