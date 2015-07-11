# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/blogilo/blogilo-4.14.10.ebuild,v 1.1 2015/07/11 11:49:28 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="KDE Blogging Client"
HOMEPAGE="http://www.kde.org/applications/internet/blogilo"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepim-common-libs)
	$(add_kdebase_dep kdepimlibs 'akonadi(+)')
	>=net-libs/libkgapi-2.2.0:4
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	composereditor-ng/
	pimcommon/
"
