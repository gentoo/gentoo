# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="The KDE Address Book"
HOMEPAGE="https://www.kde.org/applications/office/kaddressbook/"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep kdepim-common-libs)
	dev-libs/grantlee:0
	!kde-base/contactthemeeditor
"
RDEPEND="${DEPEND}"

KMEXTRA="
	grantleeeditor/contactthemeeditor
	plugins/kaddressbook/
	plugins/ktexteditor/
"
KMCOMPILEONLY="
	grantleetheme/
	kaddressbookgrantlee/
"
KMEXTRACTONLY="
	akonadi_next/
	calendarsupport/
	grantleeeditor/grantleethemeeditor/
	libkleo/
	pimcommon/
"

KMLOADLIBS="kdepim-common-libs"

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
}
