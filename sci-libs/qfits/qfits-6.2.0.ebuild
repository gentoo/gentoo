# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ESO stand-alone C library offering easy access to FITS files"
HOMEPAGE="http://www.eso.org/projects/aot/qfits/"
SRC_URI="ftp://ftp.hq.eso.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

PATCHES=( "${FILESDIR}"/${P}-{ttest,open}.patch )

src_configure() {
	econf --disable-static
}

src_install() {
	use doc && HTML_DOCS=( html/. )
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
