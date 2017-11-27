# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune

DESCRIPTION="C library providing BLAKE2b, BLAKE2s, BLAKE2bp, BLAKE2sp"
HOMEPAGE="https://github.com/BLAKE2/libb2"
GITHASH="0d7015f6a640a63bc6c68562328e112445ea9d5c"
SRC_URI="https://github.com/BLAKE2/libb2/archive/${GITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${GITHASH}

src_prepare() {
	default
	# fix bashism
	sed -i -e 's/ == / = /' configure.ac || die
	eautoreconf  # upstream doesn't make releases
}

src_configure() {
	econf $(use_enable static)
}

src_compile() {
	# respect our CFLAGS
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	default
	prune_libtool_files
}
