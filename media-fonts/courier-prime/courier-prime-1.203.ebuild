# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/courier-prime/courier-prime-1.203.ebuild,v 1.1 2015/05/09 09:35:46 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="A redesign of Courier"
HOMEPAGE="http://www.quoteunquoteapps.com/courierprime/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

FONT_SUFFIX="ttf"
DOCS="README-CourierPrime.txt README-CourierPrimeSans.txt README-CourierPrimeSource.txt"
