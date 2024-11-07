# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_QTHELP="true"
ECM_TEST="forceoptional"
KFMIN=6.5.0
QTMIN=6.7.2
VIRTUALDBUS_TEST="true"
inherit ecm gear.kde.org

DESCRIPTION="Storage service for PIM data and libraries for PIM apps"
HOMEPAGE="https://community.kde.org/KDE_PIM/akonadi"

LICENSE="LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="+mysql postgres sqlite tools +webengine xml"

REQUIRED_USE="|| ( mysql postgres sqlite ) test? ( tools )"

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT="test"

COMMON_DEPEND="
	app-arch/xz-utils
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,mysql?,network,postgres?,sql,sqlite?,widgets,xml]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	webengine? (
		kde-apps/kaccounts-integration:6
		>=net-libs/accounts-qt-1.17[qt6(+)]
	)
	xml? ( dev-libs/libxml2 )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	test? ( sys-apps/dbus )
"
RDEPEND="${COMMON_DEPEND}
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
"

pkg_setup() {
	# Set default storage backend in order: MySQL, PostgreSQL, SQLite
	# reverse driver check to keep the order
	use sqlite && DRIVER="QSQLITE"
	use postgres && DRIVER="QPSQL"
	use mysql && DRIVER="QMYSQL"

	ecm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=$(usex tools)
		$(cmake_use_find_package webengine AccountsQt6)
		$(cmake_use_find_package webengine KAccounts6)
		$(cmake_use_find_package xml LibXml2)
	)

	ecm_src_configure
}

src_install() {
	# Who knows, maybe it accidentally fixes our permission issues
	cat <<-EOF > "${T}"/akonadiserverrc
[%General]
Driver=${DRIVER}
EOF
	insinto /usr/share/config/akonadi
	doins "${T}"/akonadiserverrc

	ecm_src_install
}

pkg_postinst() {
	ecm_pkg_postinst
	elog "You can select the storage backend in ~/.config/akonadi/akonadiserverrc."
	elog "Available drivers are:"
	use mysql && elog "  QMYSQL"
	use postgres && elog "  QPSQL"
	use sqlite && elog "  QSQLITE"
	elog "${DRIVER} has been set as your default akonadi storage backend."
}
