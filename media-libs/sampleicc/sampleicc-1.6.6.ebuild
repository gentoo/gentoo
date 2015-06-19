# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sampleicc/sampleicc-1.6.6.ebuild,v 1.4 2013/04/27 08:31:12 scarabeus Exp $

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
