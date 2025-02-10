# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utilities for working with Tidal Constituent Databases"
HOMEPAGE="https://flaterco.com/xtide/"
SRC_URI="https://flaterco.com/files/xtide/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-geosciences/libtcd-2.2.4"
RDEPEND="${DEPEND}"
