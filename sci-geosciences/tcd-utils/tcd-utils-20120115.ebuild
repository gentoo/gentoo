# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/tcd-utils/tcd-utils-20120115.ebuild,v 1.3 2013/09/02 08:14:31 ago Exp $

EAPI=5

DESCRIPTION="Utilities for working with Tidal Constituent Databases"
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sci-geosciences/libtcd-2.2.4"
RDEPEND="${DEPEND}"
