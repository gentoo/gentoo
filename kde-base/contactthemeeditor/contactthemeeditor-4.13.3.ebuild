# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/contactthemeeditor/contactthemeeditor-4.13.3.ebuild,v 1.3 2014/10/12 13:31:12 zlogene Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A contact theme editor for KAddressBook"
HOMEPAGE="http://www.kde.org/"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kaddressbook)
	$(add_kdebase_dep kmail)
"
RDEPEND="${DEPEND}"

KMCOMPILEONLY="
	kaddressbookgrantlee/
	grantleetheme/
"
KMEXTRACTONLY="
	grantleethemeeditor/
	pimcommon/
"

KMLOADLIBS="kdepim-common-libs"
