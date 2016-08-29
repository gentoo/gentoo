# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for reading/writing KVTML"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}"

src_prepare(){
	kde5_src_prepare

	if ! use test; then
		sed -e "/add_subdirectory(autotests)/ s/^/#DONT/" \
			-e "/add_subdirectory(tests)/ s/^/#DONT/" \
			-i keduvocdocument/CMakeLists.txt
	fi
}
