# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Program that simulates astronomical images"
HOMEPAGE="http://www.astromatic.net/software/skymaker"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-3"
SLOT="0"
IUSE="threads"

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable threads)
}
