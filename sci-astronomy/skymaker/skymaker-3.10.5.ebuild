# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Program that simulates astronomical images"
HOMEPAGE="http://www.astromatic.net/software/skymaker"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="threads"

RDEPEND="sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	econf $(use_enable threads)
}
