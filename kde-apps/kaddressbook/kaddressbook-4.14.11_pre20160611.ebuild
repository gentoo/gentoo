# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Address book application"
HOMEPAGE="https://www.kde.org/applications/office/kaddressbook/"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)')
	$(add_kdeapps_dep kdepim-common-libs)
	dev-libs/grantlee:0
"
RDEPEND="${DEPEND}
	!kde-base/contactthemeeditor
"

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
