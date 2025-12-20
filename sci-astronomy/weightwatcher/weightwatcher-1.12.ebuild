# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Combine weight maps and polygon for astronomical images weighting"
HOMEPAGE="http://www.astromatic.net/software/weightwatcher/"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/${P}-AR.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	use doc && dodoc doc/*
}
