# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="2.0"
KDEBASE="kdevelop"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="LL(1) parser generator used mainly by KDevelop language plugins"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${PN}-${PV%.0}.tar.xz"
LICENSE="LGPL-2+ LGPL-2.1+"
IUSE=""
[[ ${KDE_BUILD_TYPE} = release ]] && KEYWORDS="amd64 x86"

DEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	!dev-util/kdevelop-pg-qt:4
"

PATCHES=( "${FILESDIR}/${P}-flex263.patch" )

S="${WORKDIR}/${PN}-${PV%.0}"
