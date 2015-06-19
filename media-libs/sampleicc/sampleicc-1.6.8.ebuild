# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sampleicc/sampleicc-1.6.8.ebuild,v 1.1 2014/12/31 15:40:28 kensington Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="C++ library for reading, writing, manipulating, and applying ICC profiles"
HOMEPAGE="http://sampleicc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SampleICC-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="media-libs/tiff"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SampleICC-${PV}
