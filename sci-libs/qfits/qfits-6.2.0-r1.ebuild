# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ESO stand-alone C library offering easy access to FITS files"
HOMEPAGE="https://www.eso.org/sci/software/eclipse/qfits/"
SRC_URI="ftp://ftp.hq.eso.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

PATCHES=(
	"${FILESDIR}/${P}-ttest.patch"
	"${FILESDIR}/${P}-open.patch"
	"${FILESDIR}/${P}-includes.patch"
	"${FILESDIR}/${P}-m4.patch"
)

src_prepare() {
	default

	# https://bugs.gentoo.org/908483
	eautoreconf
}

src_install() {
	use doc && HTML_DOCS=( html/. )
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
