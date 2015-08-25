# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
KDE_PUNT_BOGUS_DEPS="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5 multilib pam

DESCRIPTION="KDE Plasma workspace"
KEYWORDS=" ~amd64"
IUSE="dbus +drkonqi gps prison qalculate +systemmonitor"

COMMON_DEPEND="
	$(add_plasma_dep kwayland)
	$(add_plasma_dep kwin)
	$(add_plasma_dep libkscreen)
	$(add_plasma_dep libksysguard)
	$(add_frameworks_dep baloo)
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kdesu)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
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
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep kxmlrpcclient)
	$(add_frameworks_dep networkmanager-qt)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep solid)
	dev-libs/wayland
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtgui:5[jpeg]
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/phonon[qt5]
	sys-libs/pam
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/xcb-util-keysyms
	dbus? ( dev-libs/libdbusmenu-qt[qt5] )
	drkonqi? (
		$(add_frameworks_dep kdewebkit)
		dev-qt/qtwebkit:5
	)
	gps? ( sci-geosciences/gpsd )
	prison? ( media-libs/prison:5 )
	qalculate? ( sci-libs/libqalculate )
	systemmonitor? (
		$(add_plasma_dep libksysguard processui)
	)
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kded)
	$(add_plasma_dep kde-cli-tools)
	$(add_plasma_dep milou)
	dev-qt/qdbus:5
	dev-qt/qtpaths:5
	dev-qt/qtquickcontrols:5[widgets]
	x11-apps/mkfontdir
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrdb
	x11-apps/xset
	x11-apps/xsetroot
	!kde-base/freespacenotifier
	!kde-base/libtaskmanager
	!kde-base/kcminit
	!kde-base/kdebase-startkde
	!kde-base/klipper
	!kde-base/krunner
	!kde-base/ksmserver
	!kde-base/ksplash
	!kde-base/plasma-workspace
	!kde-plasma/kio-extras
"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
"

PATCHES=(
	"${FILESDIR}/${PN}-5.4-startkde-script.patch"
	"${FILESDIR}/${PN}-5.4-consolekit2.patch"
)

RESTRICT="test"

src_prepare() {
	# whole patch should be upstreamed, doesn't work in PATCHES
	epatch "${FILESDIR}/${PN}-tests-optional.patch"

	kde5_src_prepare

	sed -e "s|\`qtpaths|\`/usr/$(get_libdir)/qt5/bin/qtpaths|" -i startkde/startkde.cmake || die

	if ! use drkonqi; then
		comment_add_subdirectory drkonqi
	fi

	if ! use systemmonitor; then
		comment_add_subdirectory systemmonitor
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package dbus dbusmenu-qt5)
		$(cmake-utils_use_find_package gps libgps)
		$(cmake-utils_use_find_package prison)
		$(cmake-utils_use_find_package qalculate Qalculate)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install

	newpamd "${FILESDIR}/kde.pam" kde
	newpamd "${FILESDIR}/kde-np.pam" kde-np

	# startup and shutdown scripts
	insinto /etc/plasma/startup
	doins "${FILESDIR}/agent-startup.sh"

	insinto /etc/plasma/shutdown
	doins "${FILESDIR}/agent-shutdown.sh"
}

pkg_postinst () {
	kde5_pkg_postinst

	echo
	elog "To enable gpg-agent and/or ssh-agent in Plasma sessions,"
	elog "edit ${EPREFIX}/etc/plasma/startup/agent-startup.sh and"
	elog "${EPREFIX}/etc/plasma/shutdown/agent-shutdown.sh"
	echo
}
