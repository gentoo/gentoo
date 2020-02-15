# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils ltprune

MYPN=CCfits
MYP=${MYPN}-${PV}

DESCRIPTION="C++ interface for cfitsio"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
SRC_URI="https://heasarc.gsfc.nasa.gov/fitsio/CCfits/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=">=sci-libs/cfitsio-3.080"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}"

DOCS=( CHANGES README.INSTALL )
PATCHES=(
	"${FILESDIR}"/${PN}-2.2-makefile.patch # avoid building cookbook by default and no rpath
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	AT_M4DIR=config/m4 eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install () {
	if use doc; then
		DOCS+=( *.pdf )
		HTML_DOCS=( html/. )
	fi
	default
	use static-libs || prune_libtool_files --all
}
