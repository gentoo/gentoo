# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_DESIGNERPLUGIN="true"
KDE_TEST="forceoptional"
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Storage service for PIM data and libraries for PIM apps"
HOMEPAGE="https://pim.kde.org/akonadi"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1+"
IUSE="+mysql postgres sqlite tools xml"

REQUIRED_USE="|| ( sqlite mysql postgres ) test? ( tools )"

# drop qtgui subslot operator when QT_MINIMAL >= 5.7.0
COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui '' '' '5=')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql 'mysql?,postgres?')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	x11-misc/shared-mime-info
	sqlite? ( dev-db/sqlite:3 )
	tools? ( xml? ( dev-libs/libxml2 ) )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	dev-libs/libxslt
	test? ( sys-apps/dbus )
"
RDEPEND="${COMMON_DEPEND}
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	!kde-apps/kdepimlibs
"

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-16.07.80-mysql56-crash.patch" )

pkg_setup() {
	# Set default storage backend in order: MySQL, SQLite PostgreSQL
	# reverse driver check to keep the order
	if use postgres; then
		DRIVER="QPSQL"
		AVAILABLE+=" ${DRIVER}"
	fi

	if use sqlite; then
		DRIVER="QSQLITE3"
		AVAILABLE+=" ${DRIVER}"
	fi

	if use mysql; then
		DRIVER="QMYSQL"
		AVAILABLE+=" ${DRIVER}"
	fi

	# Notify about MySQL is recommend by upstream
	if use sqlite || has_version "<${CATEGORY}/${P}[sqlite]"; then
		ewarn
		ewarn "We strongly recommend you change your Akonadi database backend to MySQL in your"
		ewarn "user configuration. This is the backend recommended by KDE upstream."
		ewarn "In particular, kde-apps/kmail-4.10 does not work properly with the sqlite"
		ewarn "backend anymore."
		ewarn "You can select the backend in your ~/.config/akonadi/akonadiserverrc."
		ewarn "Available drivers are:${AVAILABLE}"
		ewarn
	fi
}

src_configure() {
	local mycmakeargs=(
		-DAKONADI_BUILD_QSQLITE=$(usex sqlite)
		-DBUILD_TOOLS=$(usex tools)
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON
	)

	kde5_src_configure
}

src_install() {
	# Who knows, maybe it accidentally fixes our permission issues
	cat <<-EOF > "${T}"/akonadiserverrc
[%General]
Driver=${DRIVER}
EOF
	insinto /usr/share/config/akonadi
	doins "${T}"/akonadiserverrc

	kde5_src_install
}

pkg_postinst() {
	elog "${DRIVER} has been set as your default akonadi storage backend."
	elog "You can override it in your ~/.config/akonadi/akonadiserverrc."
	elog "Available drivers are: ${AVAILABLE}"
}
