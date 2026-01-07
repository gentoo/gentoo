# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MYPN=CCfits
MYP=${MYPN}-${PV}

DESCRIPTION="C++ interface for cfitsio"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
SRC_URI="https://heasarc.gsfc.nasa.gov/fitsio/CCfits/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc"

RDEPEND=">=sci-libs/cfitsio-3.080"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}"

# avoid building cookbook by default and no rpath
PATCHES=( "${FILESDIR}"/${PN}-2.2-makefile.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	AT_M4DIR=config/m4 eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	if use doc; then
		DOCS+=( *.pdf )
		HTML_DOCS=( html/. )
	fi
	default

	find "${ED}" -name '*.la' -delete || die
}
