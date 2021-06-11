# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Resample and coadd astronomical FITS images"
HOMEPAGE="http://www.astromatic.net/software/swarp"
SRC_URI="https://github.com/astromatic/swarp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cfitsio doc threads"

RDEPEND="cfitsio? ( sci-libs/cfitsio )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with cfitsio) \
		$(use_enable threads)
}

src_install() {
	default
	use doc && dodoc -r doc/.
}
