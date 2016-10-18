# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KMNAME="kdepim"
inherit kde5

DESCRIPTION="Viewer for TNEF attachments (proprietary MS Outlook/Exchange Server format)"
HOMEPAGE="https://www.kde.org/"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libktnef)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_prepare() {
	# ktnef subproject does not contain doc nor searches for DocTools
	# at least until properly split upstream
	echo "add_subdirectory(doc)" >> CMakeLists.txt || die "Failed to add doc dir"

	mkdir doc || die "Failed to create doc dir"
	mv ../doc/${PN} doc || die "Failed to move handbook"
	cat <<-EOF > doc/CMakeLists.txt
find_package(KF5DocTools)
add_subdirectory(${PN})
EOF
	kde5_src_prepare
}
