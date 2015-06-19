# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krcstat/krcstat-0.7.6.ebuild,v 1.3 2015/06/04 18:57:33 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A Gentoo system management tool"
HOMEPAGE="http://www.binro.org"
SRC_URI="http://binro.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep konsole)
"
RDEPEND="${DEPEND}"
