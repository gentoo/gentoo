# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for interacting with LDAP servers"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/cyrus-sasl
	net-nds/openldap
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

src_prepare() {
	kde5_src_prepare

	if ! use handbook ; then
		sed -e "/add_subdirectory(doc)/I s/^/#DONOTCOMPILE /" \
			-i kioslave/CMakeLists.txt || die "failed to comment add_subdirectory(doc)"
	fi
}
