# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/akonadiconsole/akonadiconsole-4.14.10.ebuild,v 1.1 2015/07/11 11:49:27 johu Exp $

EAPI=5

KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="Akonadi developer console"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=app-office/akonadi-server-1.12.90
	$(add_kdebase_dep kdepimlibs 'akonadi(+)')
	$(add_kdebase_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	akonadi_next/
	calendarsupport/
	messageviewer/
"
