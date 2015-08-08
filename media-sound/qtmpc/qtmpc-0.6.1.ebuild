# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="QtMPC-${PV}"
inherit kde4-base

DESCRIPTION="Qt MPD client with a tree view music library interface"
HOMEPAGE="http://lowblog.nl/category/qtmpc/"
SRC_URI="http://files.lowblog.nl/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/QtMPC"

PATCHES=( "${FILESDIR}/${P}-underlinking.patch" )
