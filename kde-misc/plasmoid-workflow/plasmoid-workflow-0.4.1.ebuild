# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasmoid-workflow/plasmoid-workflow-0.4.1.ebuild,v 1.2 2014/08/05 16:31:44 mrueg Exp $

EAPI=5

KDE_LINGUAS="de el en es fr pt"
inherit kde4-base

DESCRIPTION="Plasmoid that integrates Activities, Virtual Desktops and Tasks Functionalities in one component"
HOMEPAGE="http://kde-look.org/content/show.php/?content=147428"
SRC_URI="http://www.opentoolsandspace.org/Art/WorkFlow/0.4.x/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_kdebase_dep kactivities)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep plasma-workspace)
"
RDEPEND=${DEPEND}

pkg_postinst() {
	elog "If you want to use the WorkFlow KWin script, install it from the KWin Script manager."
	elog "The WorkFlow plasmoid package is a dependancy for the WorkFlow KWin script to work."
}
