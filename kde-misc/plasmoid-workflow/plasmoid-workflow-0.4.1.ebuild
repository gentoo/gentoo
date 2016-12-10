# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="de el en es fr pt"
inherit kde4-base

DESCRIPTION="Integrates Activities, Virtual Desktops and Tasks in one component"
HOMEPAGE="http://kde-look.org/content/show.php/?content=147428"
SRC_URI="http://www.opentoolsandspace.org/Art/WorkFlow/0.4.x/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	kde-frameworks/kactivities:4
	kde-plasma/libkworkspace:4
	kde-plasma/plasma-workspace:4
"
RDEPEND=${DEPEND}

pkg_postinst() {
	elog "If you want to use the WorkFlow KWin script, install it from the KWin Script manager."
	elog "The WorkFlow plasmoid package is a dependancy for the WorkFlow KWin script to work."
}
