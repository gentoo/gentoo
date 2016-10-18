# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for interacting with LDAP servers"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_kdeapps_dep kmbox)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	net-nds/openldap
	ssl? ( dev-libs/cyrus-sasl )
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-kioslaves
"

src_prepare() {
	kde5_src_prepare

	if ! use_if_iuse handbook ; then
		sed -e "/add_subdirectory(doc)/I s/^/#DONOTCOMPILE /" \
			-i kioslave/CMakeLists.txt || die "failed to comment add_subdirectory(doc)"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package ssl Sasl2)
	)

	kde5_src_configure
}
