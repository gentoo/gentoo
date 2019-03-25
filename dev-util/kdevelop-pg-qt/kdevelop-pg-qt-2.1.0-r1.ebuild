# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="LL(1) parser generator used mainly by KDevelop language plugins"
HOMEPAGE="https://www.kdevelop.org/"
LICENSE="LGPL-2+ LGPL-2.1+"
IUSE=""

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	!dev-util/kdevelop-pg-qt:4
"
