# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/fisicalab/fisicalab-0.3.5.ebuild,v 1.1 2015/06/01 10:01:45 voyageur Exp $

EAPI=5
inherit gnustep-2

DESCRIPTION="educational application to solve physics problems"
HOMEPAGE="http://www.gnu.org/software/fisicalab"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-libs/gsl-1.10
	>=virtual/gnustep-back-0.16.0"
RDEPEND="${DEPEND}"
