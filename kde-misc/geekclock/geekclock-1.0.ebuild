# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/geekclock/geekclock-1.0.ebuild,v 1.1 2013/06/17 23:31:02 creffett Exp $

EAPI=5

inherit kde4-base

MY_PN="geek-clock-plasmoid"

DESCRIPTION="Geeky Clock KDE4 Plasmoid"
HOMEPAGE="http://kde-look.org/content/show.php/Geek+Clock?content=107807"
SRC_URI="http://w2f2.com/projects/${PN}/${MY_PN}-${PV}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"

S="${WORKDIR}/${MY_PN}-${PV}-src"
