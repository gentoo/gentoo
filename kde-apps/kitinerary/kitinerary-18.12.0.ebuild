# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Data Model and Extraction System for Travel Reservation information"
HOMEPAGE="https://www.kde.org/applications/office/kontact/"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="pdf"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep kpkpass)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	sys-libs/zlib
	pdf? ( app-text/poppler:=[qt5] )
"
RDEPEND="${DEPEND}
	!<kde-apps/kdepim-addons-18.07.80
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package pdf Poppler)
	)
	kde5_src_configure
}
