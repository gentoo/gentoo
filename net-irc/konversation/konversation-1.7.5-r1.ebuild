# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="User friendly IRC Client"
HOMEPAGE="https://kde.org/applications/internet/konversation/ https://konversation.kde.org"
SRC_URI="mirror://kde/stable/${PN}/${PV/_/-}/src/${P/_/-}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+crypt"

BDEPEND="sys-devel/gettext"
DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	media-libs/phonon[qt5(+)]
	crypt? ( app-crypt/qca:2[qt5(+)] )
"
RDEPEND="${DEPEND}
	crypt? ( app-crypt/qca:2[ssl] )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-regex-for-cap-ack.patch
	"${FILESDIR}"/${P}-missing-header.patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package crypt Qca-qt5)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install

	# Bug 616162
	insinto /etc/xdg
	doins "${FILESDIR}"/konversationrc
}
