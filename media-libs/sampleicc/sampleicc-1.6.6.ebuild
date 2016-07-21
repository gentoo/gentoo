# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="C++ library for reading, writing, manipulating, and applying ICC profiles"
HOMEPAGE="http://sampleicc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SampleICC-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="media-libs/tiff"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SampleICC-${PV}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files --all
}
