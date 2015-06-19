# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/stiff/stiff-2.1.3.ebuild,v 1.2 2012/07/09 23:55:06 bicatali Exp $

EAPI=4

DESCRIPTION="Converts astronomical FITS images to the TIFF format"
HOMEPAGE="http://www.astromatic.net/software/stiff"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc threads"

RDEPEND="media-libs/tiff
	virtual/jpeg
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable threads)
}

src_install () {
	default
	use doc && dodoc doc/*
}
