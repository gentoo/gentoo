# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
ECM_TEST="forceoptional"
KFMIN=5.75.0
QTMIN=5.15.2
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
inherit ecm kde.org readme.gentoo-r1

DESCRIPTION="Storage service for PIM data and libraries for PIM apps"
HOMEPAGE="https://community.kde.org/KDE_PIM/akonadi"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="+kaccounts +mysql postgres sqlite tools xml"

REQUIRED_USE="|| ( mysql postgres sqlite ) test? ( tools )"

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT+=" test"

COMMON_DEPEND="
	app-arch/xz-utils
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[mysql?,postgres?]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	kaccounts? (
		>=kde-apps/kaccounts-integration-20.08.3:5
		net-libs/accounts-qt
	)
	sqlite? (
		dev-db/sqlite:3
		>=dev-qt/qtsql-${QTMIN}:5=[sqlite]
	)
	xml? ( dev-libs/libxml2 )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	dev-libs/libxslt
	test? ( sys-apps/dbus )
"
RDEPEND="${COMMON_DEPEND}
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
"

PATCHES=( "${FILESDIR}/${PN}-18.12.2-mysql56-crash.patch" )

pkg_setup() {
	# Set default storage backend in order: MySQL, PostgreSQL, SQLite
	# reverse driver check to keep the order
	use sqlite && DRIVER="QSQLITE3"
	use postgres && DRIVER="QPSQL"
	use mysql && DRIVER="QMYSQL"

	if use mysql && has_version "${CATEGORY}/${PN}[mysql]" && has_version "dev-db/mariadb"; then
		ewarn
		ewarn "Attention: Make sure to read README.gentoo after install."
		ewarn
	fi

	if use sqlite || has_version "<${CATEGORY}/${P}[sqlite]"; then
		ewarn "We strongly recommend you change your Akonadi database backend to"
		ewarn "either MariaDB/MySQL or PostgreSQL in your user configuration."
		ewarn "In particular, kde-apps/kmail does not work properly with the sqlite backend."
	fi

	ecm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kaccounts AccountsQt5)
		$(cmake_use_find_package kaccounts KAccounts)
		-DAKONADI_BUILD_QSQLITE=$(usex sqlite)
		-DBUILD_TOOLS=$(usex tools)
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
	readme.gentoo_create_doc
}

pkg_postinst() {
	ecm_pkg_postinst
	elog "You can select the storage backend in ~/.config/akonadi/akonadiserverrc."
	elog "Available drivers are:"
	use mysql && elog "  QMYSQL"
	use postgres && elog "  QPSQL"
	use sqlite && elog "  QSQLITE3"
	elog "${DRIVER} has been set as your default akonadi storage backend."
	use mysql && elog
	use mysql && FORCE_PRINT_ELOG=1 readme.gentoo_print_elog
}
