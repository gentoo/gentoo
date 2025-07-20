# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="5.2"
ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KDE_ORG_COMMIT=45f6113430a2656e8c432cc817a2d273c4afc5f8
KFMIN=5.115.0
QTMIN=5.15.12
VIRTUALDBUS_TEST="true"
inherit ecm kde.org optfeature

DESCRIPTION="Personal finance manager based on KDE Frameworks"
HOMEPAGE="https://kmymoney.org/"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64"
IUSE="calendar hbci holidays sql sqlcipher"
[[ ${KDE_BUILD_TYPE} = live ]] && IUSE+=" experimental"

REQUIRED_USE="sqlcipher? ( sql )"

RDEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx(-),qt5(-)]
	<app-office/libalkimia-8.2.0_p20250713:=
	dev-libs/gmp:0=[cxx(+)]
	dev-libs/kdiagram:5
	dev-libs/libgpg-error
	dev-libs/libofx:=
	>=dev-libs/qtkeychain-0.14.2:=[qt5(-)]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
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
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	calendar? ( dev-libs/libical:= )
	hbci? (
		>=dev-qt/qtdeclarative-${QTMIN}:5
		>=net-libs/aqbanking-6.5.0
		>=sys-libs/gwenhywfar-5.10.1:=[qt5(-)]
	)
	holidays? ( >=kde-frameworks/kholidays-${KFMIN}:5 )
	sql? ( >=dev-qt/qtsql-${QTMIN}:5[sqlite] )
	sqlcipher? ( dev-db/sqlcipher )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	ecm_pkg_setup

	if [[ ${KDE_BUILD_TYPE} = live ]] && use experimental; then
		ewarn "USE experimental set: Building unfinished features."
		ewarn "This *will* chew up your data. You have been warned."
	fi
}

src_prepare() {
	ecm_src_prepare

	sed -e "/find_program.*CCACHE_PROGRAM/s/^/# /" \
		-e "/if.*CCACHE_PROGRAM/s/CCACHE_PROGRAM/0/" \
		-i CMakeLists.txt # no, no no.
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_WOOB=OFF # ported to Py3; not yet re-added in Gentoo
		-DUSE_QT_DESIGNER=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5Activities=ON
		-DENABLE_LIBICAL=$(usex calendar)
		-DENABLE_KBANKING=$(usex hbci)
		$(cmake_use_find_package holidays KF5Holidays)
		-DENABLE_SQLSTORAGE=$(usex sql)
		$(cmake_use_find_package sql Qt5Sql)
		-DENABLE_SQLCIPHER=$(usex sqlcipher)
	)
	[[ ${KDE_BUILD_TYPE} = live ]] &&
		mycmakeargs+=( -DENABLE_COSTCENTER=$(usex experimental) )

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
	ecm_pkg_postinst
}
