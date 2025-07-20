# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="5.2"
ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KDE_ORG_COMMIT=091820c817af360ce5d67fd5dd593fee72eaefc9
KFMIN=6.9.0
QTMIN=6.8.1
VIRTUALDBUS_TEST="true"
inherit ecm kde.org optfeature xdg

DESCRIPTION="Personal finance manager based on KDE Frameworks"
HOMEPAGE="https://kmymoney.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="activities calendar hbci holidays sql sqlcipher"
[[ ${KDE_BUILD_TYPE} = live ]] && IUSE+=" experimental"

REQUIRED_USE="sqlcipher? ( sql )"

COMMON_DEPEND="
	dev-cpp/gpgmepp:=
	dev-libs/qgpgme:=
	>=app-office/libalkimia-8.2.0_p20250713:=
	dev-libs/gmp:0=[cxx(+)]
	dev-libs/kdiagram:6
	dev-libs/libgpg-error
	dev-libs/libofx:=
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql?,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6 )
	calendar? ( dev-libs/libical:= )
	hbci? (
		>=dev-qt/qtdeclarative-${QTMIN}:6
		>=net-libs/aqbanking-6.5.0
		>=sys-libs/gwenhywfar-5.12.1:=[qt6]
	)
	holidays? ( >=kde-frameworks/kholidays-${KFMIN}:6 )
	sql? ( >=dev-qt/qtbase-${QTMIN}:6[sqlite] )
	sqlcipher? ( dev-db/sqlcipher )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
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
		-DBUILD_WITH_QT6=ON # high level CMake fix
		-DENABLE_WOOB=OFF # ported to Py3; not yet re-added in Gentoo
		-DUSE_QT_DESIGNER=OFF
		$(cmake_use_find_package activities PlasmaActivities)
		-DENABLE_LIBICAL=$(usex calendar)
		-DENABLE_KBANKING=$(usex hbci)
		$(cmake_use_find_package holidays KF6Holidays)
		-DENABLE_SQLSTORAGE=$(usex sql)
		$(cmake_use_find_package sql Qt6Sql)
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
}
