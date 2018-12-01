# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5 qmake-utils

DESCRIPTION="KDE Plasma workspace"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="appstream +calendar geolocation gps prison qalculate +semantic-desktop systemd"

REQUIRED_USE="gps? ( geolocation )"

COMMON_DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kjs)
	$(add_frameworks_dep kjsembed)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep solid)
	$(add_plasma_dep kscreenlocker)
	$(add_plasma_dep kwin)
	$(add_plasma_dep libksysguard)
	$(add_plasma_dep libkworkspace)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui 'jpeg')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	media-libs/phonon[qt5(+)]
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	appstream? ( dev-libs/appstream[qt5] )
	calendar? ( $(add_frameworks_dep kholidays) )
	geolocation? ( $(add_frameworks_dep networkmanager-qt) )
	gps? ( sci-geosciences/gpsd )
	prison? ( $(add_frameworks_dep prison) )
	qalculate? ( sci-libs/libqalculate:= )
	semantic-desktop? ( $(add_frameworks_dep baloo) )
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtconcurrent)
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kded)
	$(add_frameworks_dep kdesu)
	$(add_kdeapps_dep kio-extras)
	$(add_plasma_dep ksysguard)
	$(add_plasma_dep milou)
	$(add_plasma_dep plasma-integration)
	$(add_qt_dep qdbus)
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtpaths)
	$(add_qt_dep qtquickcontrols 'widgets')
	app-text/iso-codes
	x11-apps/mkfontdir
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrdb
	x11-apps/xset
	x11-apps/xsetroot
	systemd? ( sys-apps/dbus[user-session] )
	!systemd? ( sys-apps/dbus )
	!kde-plasma/freespacenotifier:4
	!kde-plasma/libtaskmanager:4
	!kde-plasma/kcminit:4
	!kde-plasma/kdebase-startkde:4
	!kde-plasma/klipper:4
	!kde-plasma/krunner:4
	!kde-plasma/ksmserver:4
	!kde-plasma/ksplash:4
	!kde-plasma/plasma-workspace:4
"
PDEPEND="
	$(add_plasma_dep kde-cli-tools)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.4-startkde-script.patch"
	"${FILESDIR}/${PN}-5.10-startplasmacompositor-script.patch"
	"${FILESDIR}/${PN}-5.12.80-tests-optional.patch"
	"${FILESDIR}/${PN}-5.14.2-split-libkworkspace.patch"
)

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare

	sed -e "s|\`qtpaths|\`$(qt5_get_bindir)/qtpaths|" \
		-i startkde/startkde.cmake startkde/startplasmacompositor.cmake || die

	cmake_comment_add_subdirectory libkworkspace
	# delete colliding libkworkspace translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -name "libkworkspace*" -delete || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_xembed-sni-proxy=OFF
		$(cmake-utils_use_find_package appstream AppStreamQt)
		$(cmake-utils_use_find_package calendar KF5Holidays)
		$(cmake-utils_use_find_package geolocation KF5NetworkManagerQt)
		$(cmake-utils_use_find_package prison KF5Prison)
		$(cmake-utils_use_find_package qalculate Qalculate)
		$(cmake-utils_use_find_package semantic-desktop KF5Baloo)
	)

	use gps && mycmakeargs+=( $(cmake-utils_use_find_package gps libgps) )

	kde5_src_configure
}

src_install() {
	kde5_src_install

	# startup and shutdown scripts
	insinto /etc/plasma/startup
	doins "${FILESDIR}/10-agent-startup.sh"

	insinto /etc/plasma/shutdown
	doins "${FILESDIR}/10-agent-shutdown.sh"
}

pkg_postinst () {
	kde5_pkg_postinst

	elog "To enable gpg-agent and/or ssh-agent in Plasma sessions,"
	elog "edit ${EPREFIX}/etc/plasma/startup/10-agent-startup.sh and"
	elog "${EPREFIX}/etc/plasma/shutdown/10-agent-shutdown.sh"
}
