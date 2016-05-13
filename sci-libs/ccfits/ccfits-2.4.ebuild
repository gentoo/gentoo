# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils autotools

MYPN=CCfits
MYP=${MYPN}-${PV}

DESCRIPTION="C++ interface for cfitsio"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
SRC_URI="${HOMEPAGE}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=">=sci-libs/cfitsio-3.080"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}"

src_prepare() {
	# avoid building cookbook by default and no rpath
	epatch "${FILESDIR}"/${PN}-2.2-makefile.patch
	AT_M4DIR=config/m4 eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install () {
	default
	use doc && dodoc *.pdf && dohtml -r html/*
}
