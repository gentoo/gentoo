# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="C++ library for reading, writing, manipulating, and applying ICC profiles"
HOMEPAGE="http://sampleicc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SampleICC-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="media-libs/tiff"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SampleICC-${PV}
