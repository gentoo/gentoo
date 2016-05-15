# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="A multicast protocol to support Bible software shared co-navigation"
HOMEPAGE="http://www.crosswire.org/wiki/BibleSync"
SRC_URI="mirror://sourceforge/gnomesword/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND=""
