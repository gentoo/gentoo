# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/quickaccess/quickaccess-0.8.2-r1.ebuild,v 1.4 2015/06/04 18:57:33 kensington Exp $

EAPI=5

KDE_LINGUAS="de es fr gl nl pt_BR sv tr zh_CN"
inherit kde4-base

MY_PN="plasma-widget-${PN}"
MY_P="${MY_PN}-${PV}-2"

DESCRIPTION="KDE4 plasmoid. Designed for the panel, provides quick access to the most used folders"
HOMEPAGE="http://kde-look.org/content/show.php?content=134442"
SRC_URI="http://kde-look.org/CONTENT/content-files/134442-${MY_P}.zip"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkonq)"
RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"

S="${WORKDIR}/${MY_P}"
