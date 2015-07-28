# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-runtime/kdepim-runtime-4.14.3.ebuild,v 1.7 2015/07/28 20:35:12 johu Exp $

EAPI=5

KMNAME="kdepim-runtime"
inherit kde4-base

DESCRIPTION="KDE PIM runtime plugin collection"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug facebook google kolab"

RESTRICT="test"
# Would need test programs _testrunner and akonaditest from kdepimlibs, see bug 313233

DEPEND="
	>=app-office/akonadi-server-1.12.90
	dev-libs/boost:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	$(add_kdebase_dep kdepimlibs)
	x11-misc/shared-mime-info
	facebook? ( net-libs/libkfbapi:4 )
	google? ( >=net-libs/libkgapi-2.0:4 )
	kolab? ( >=net-libs/libkolab-0.5 )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdepim-icons)
	!kde-misc/akonadi-google
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package facebook LibKFbAPI)
		$(cmake-utils_use_find_package google LibKGAPI2)
		$(cmake-utils_use_find_package kolab Libkolab)
		$(cmake-utils_use_find_package kolab Libkolabxml)
	)

	kde4-base_src_configure
}
