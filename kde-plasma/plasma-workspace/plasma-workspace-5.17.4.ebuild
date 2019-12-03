# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.64.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE Plasma workspace"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="appstream +calendar geolocation gps qalculate qrcode +semantic-desktop systemd"

REQUIRED_USE="gps? ( geolocation )"

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
COMMON_DEPEND="
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kactivities-stats-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kded-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	>=kde-plasma/kwin-${PVCUT}:5
	>=kde-plasma/libkscreen-${PVCUT}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5=[jpeg]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
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
	calendar? ( >=kde-frameworks/kholidays-${KFMIN}:5 )
	geolocation? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:5 )
	gps? ( sci-geosciences/gpsd )
	qalculate? ( sci-libs/libqalculate:= )
	qrcode? ( >=kde-frameworks/prison-${KFMIN}:5 )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kdesu-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-apps/kio-extras-19.04.3:5
	>=kde-plasma/ksysguard-${PVCUT}:5
	>=kde-plasma/milou-${PVCUT}:5
	>=kde-plasma/plasma-integration-${PVCUT}:5
	>=dev-qt/qdbus-${QTMIN}:5
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtpaths-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5[widgets]
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	app-text/iso-codes
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrdb
	x11-apps/xsetroot
	systemd? ( sys-apps/dbus[user-session] )
	!systemd? ( sys-apps/dbus )
	!<kde-plasma/plasma-desktop-5.16.80:5
"
PDEPEND="
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

PATCHES=(
	"${FILESDIR}/${PN}-5.14.2-split-libkworkspace.patch"
	"${FILESDIR}/${PN}-5.17.2-waylandsessionrename.patch"
)

RESTRICT+=" test"

# used for agent scripts migration
OLDST=/etc/plasma/startup/10-agent-startup.sh
NEWST=/etc/xdg/plasma-workspace/env/10-agent-startup.sh
OLDSH=/etc/plasma/shutdown/10-agent-shutdown.sh
NEWSH=/etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh

src_prepare() {
	ecm_src_prepare

	cmake_comment_add_subdirectory libkworkspace
	# delete colliding libkworkspace translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -name "libkworkspace*" -delete || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_xembed-sni-proxy=OFF
		$(cmake_use_find_package appstream AppStreamQt)
		$(cmake_use_find_package calendar KF5Holidays)
		$(cmake_use_find_package geolocation KF5NetworkManagerQt)
		$(cmake_use_find_package qalculate Qalculate)
		$(cmake_use_find_package qrcode KF5Prison)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
	)

	use gps && mycmakeargs+=( $(cmake_use_find_package gps libgps) )

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# default startup and shutdown scripts
	insinto "$(dirname ${NEWST})"
	doins "${FILESDIR}/$(basename ${NEWST})"

	insinto "$(dirname ${NEWSH})"
	doins "${FILESDIR}/$(basename ${NEWSH})"
	fperms +x "${NEWSH}"
}

pkg_preinst() {
	ecm_pkg_preinst

	# migrate existing agent scripts to new layout if no files there yet
	if [[ -r "${EROOT}${OLDST}" && ! -f "${EROOT}${NEWST}" ]]; then
		mkdir -p "${EROOT}$(dirname ${NEWST})" && cp "${EROOT}${OLDST}" "${EROOT}${NEWST}" && \
		elog "${EROOT}${OLDST} has been migrated to ${EROOT}${NEWST}, please delete old file."
	fi
	if [[ -r "${EROOT}${OLDSH}" && ! -f "${EROOT}${NEWSH}" ]]; then
		mkdir -p "${EROOT}$(dirname ${NEWSH})" && cp "${EROOT}${OLDSH}" "${EROOT}${NEWSH}" && \
		chmod +x "${EROOT}${NEWSH}" && \
		elog "${EROOT}${OLDSH} has been migrated to ${EROOT}${NEWSH}, please delete old file."
	fi
}

pkg_postinst () {
	ecm_pkg_postinst

	# warn about any leftover user scripts
	if [[ -d "${EROOT}"/etc/plasma/startup && -n "$(ls "${EROOT}"/etc/plasma/startup)" ]] || \
	[[ -d "${EROOT}"/etc/plasma/shutdown && -n "$(ls "${EROOT}"/etc/plasma/shutdown)" ]]; then
		elog "You appear to have scripts in ${EROOT}/etc/plasma/{startup,shutdown}."
		elog "They will no longer work since plasma-workspace-5.17"
	fi

	elog " * Edit ${EROOT}${NEWST} and uncomment"
	elog "   the lines enabling ssh-agent."
	elog " * Edit ${EROOT}${NEWSH} uncomment"
	elog "   the respective lines to properly kill the agent when the session ends."
}
