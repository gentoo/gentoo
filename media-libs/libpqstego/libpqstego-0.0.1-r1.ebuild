# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library for Perturbed Quantization Steganography"
HOMEPAGE="https://sourceforge.net/projects/pqstego/"
SRC_URI="mirror://sourceforge/${PN/lib}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-libs/gsl:=[cblas-external]"

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
