# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

MY_PN="geek-clock-plasmoid"

DESCRIPTION="Geeky Clock Plasmoid"
HOMEPAGE="http://kde-look.org/content/show.php/Geek+Clock?content=107807"
SRC_URI="http://w2f2.com/projects/${PN}/${MY_PN}-${PV}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	kde-plasma/plasma-workspace:4
"

S="${WORKDIR}/${MY_PN}-${PV}-src"
