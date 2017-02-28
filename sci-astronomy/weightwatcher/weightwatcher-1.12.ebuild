# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Combine weight maps and polygon for astronomical images weighting"
HOMEPAGE="http://www.astromatic.net/software/weightwatcher/"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install () {
	default
	use doc && dodoc doc/*
}
