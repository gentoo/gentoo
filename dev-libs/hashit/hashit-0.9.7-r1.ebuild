# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Generic C hash library which supports multiple collision handling methods"
HOMEPAGE="http://www.pleyades.net/david/projects/hashit"
SRC_URI="http://www.pleyades.net/david/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

PATCHES=( "${FILESDIR}/${P}-pkgconfig.patch" )
