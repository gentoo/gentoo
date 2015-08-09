# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils autotools

DESCRIPTION="Resample and coadd astronomical FITS images"
HOMEPAGE="http://astromatic.iap.fr/software/swarp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc threads"
RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-nodoc.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable threads)
}

src_install() {
	default
	use doc && dodoc doc/*
}
