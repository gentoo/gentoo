# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kdepim-runtime"
EGIT_BRANCH="KDE/4.14"
inherit kde4-base

DESCRIPTION="KDE PIM runtime plugin collection"
COMMIT_ID="bb194cc299839cb00b808c9c5740169815ba9e39"
SRC_URI="https://quickgit.kde.org/?p=kdepim-runtime.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${KMNAME}-${PV}.tar.gz"
S=${WORKDIR}/${PN}

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug google kolab"

RESTRICT="test"
# Would need test programs _testrunner and akonaditest from kdepimlibs, see bug 313233

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)' ${PV})
	>=app-office/akonadi-server-1.12.90
	dev-libs/boost:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	x11-misc/shared-mime-info
	google? ( >=net-libs/libkgapi-2.0:4 )
	kolab? ( >=net-libs/libkolab-0.5 )
"
RDEPEND="${DEPEND}
	kde-frameworks/oxygen-icons:5
	!kde-misc/akonadi-google
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package google LibKGAPI2)
		$(cmake-utils_use_find_package kolab Libkolab)
		$(cmake-utils_use_find_package kolab Libkolabxml)
	)

	kde4-base_src_configure
}
