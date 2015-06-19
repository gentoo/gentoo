# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/hashit/hashit-0.9.7-r1.ebuild,v 1.1 2015/04/04 16:02:28 kensington Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Generic hash library implemented in C which supports multiple collision handling methods"
HOMEPAGE="http://www.pleyades.net/david/hashit.php"
SRC_URI="http://www.pleyades.net/david/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

PATCHES=( "${FILESDIR}/${P}-pkgconfig.patch" )
