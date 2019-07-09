# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="c8b3da65bfd289d0a0262aa673aa6b697022d4a3"
inherit kde5

DESCRIPTION="An input method frontend for Plasma"
HOMEPAGE="https://www.linux-apps.com/content/show.php?content=140967"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="libressl scim semantic-desktop"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	app-i18n/ibus
	dev-libs/glib:2
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/libpng:0=[apng]
	x11-libs/libX11
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	scim? (
		>=app-i18n/scim-1.4.9
		dev-libs/dbus-c++
	)
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
"
RDEPEND="${DEPEND}
	!kde-misc/kimtoy:4
	>=app-i18n/fcitx-4.0
"

src_prepare() {
	kde5_src_prepare

	# bug 581736
	cmake_comment_add_subdirectory po
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package scim SCIM)
		$(cmake-utils_use_find_package scim DBusCXX)
		$(cmake-utils_use_find_package semantic-desktop KF5FileMetaData)
	)

	kde5_src_configure
}

S="${WORKDIR}/${PN}-${COMMIT}"
