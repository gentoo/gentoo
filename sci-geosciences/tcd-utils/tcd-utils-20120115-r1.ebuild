# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utilities for working with Tidal Constituent Databases"
HOMEPAGE="https://flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sci-geosciences/libtcd-2.2.4"
RDEPEND="${DEPEND}"
