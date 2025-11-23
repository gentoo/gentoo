# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for Perturbed Quantization Steganography"
HOMEPAGE="https://sourceforge.net/projects/pqstego/"
SRC_URI="https://downloads.sourceforge.net/${PN/lib}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-libs/gsl:=[cblas-external]"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
