# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knotes/knotes-4.14.8.ebuild,v 1.3 2015/06/13 08:34:12 zlogene Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="KDE Notes application"
HOMEPAGE="http://www.kde.org/applications/utilities/knotes/"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

KMCOMPILEONLY="
	noteshared/
"

KMEXTRACTONLY="
	akonadi_next/
	pimcommon/
"

KMLOADLIBS="kdepim-common-libs"
