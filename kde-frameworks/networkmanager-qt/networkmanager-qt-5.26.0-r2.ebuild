# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PV="5.27.0"
inherit kde5

DESCRIPTION="NetworkManager bindings for Qt"
SRC_URI="mirror://kde/stable/frameworks/${MY_PV%.0}/${PN}-${MY_PV}.tar.xz"

LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm x86"
IUSE="teamd"

COMMON_DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtnetwork)
	|| (
		>=net-misc/networkmanager-1.4.0-r1[consolekit,teamd=]
		>=net-misc/networkmanager-1.4.0-r1[systemd,teamd=]
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!net-libs/libnm-qt:5
"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}/${PN}-5.27.0-tests.patch" )

src_prepare(){
	sed -e "s/${MY_PV}/${PV}/" \
		-i CMakeLists.txt || die "Failed to lower ECM version requirement"
	kde5_src_prepare
}
