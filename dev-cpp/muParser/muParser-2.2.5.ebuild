# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Library for parsing mathematical expressions"
HOMEPAGE="http://muparser.beltoforion.de/"
SRC_URI="https://github.com/beltoforion/muparser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc test"

S=${WORKDIR}/muparser-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.32-parallel-build.patch
	sed -i \
		-e 's:-O2::g' \
		configure || die
}

src_configure() {
	econf $(use_enable test samples)
}

src_test() {
	cat > test.sh <<- EOFTEST
	LD_LIBRARY_PATH="${S}/lib" samples/example1/example1 <<- EOF
	quit
	EOF
	EOFTEST
	sh ./test.sh || die "test failed"
}

src_install() {
	default
	dodoc Changes.txt
}
