# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/muParser/muParser-2.2.2.ebuild,v 1.3 2012/08/12 16:35:57 maekke Exp $

EAPI=4

inherit eutils

MY_PN=${PN/P/p}
MY_P=${MY_PN}_v${PV/./}

DESCRIPTION="Library for parsing mathematical expressions"
HOMEPAGE="http://muparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/P/p}/${PN/P/p}/Version%20${PV}/${PN/P/p}_v${PV//./_}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc test"

RDEPEND=""
DEPEND="app-arch/unzip"

S="${WORKDIR}"/${PN/P/p}_v${PV//./_}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.32-build.patch \
		"${FILESDIR}"/${PN}-1.32-parallel-build.patch
	sed -i \
		-e 's:-O2::g' \
		configure || die
}

src_configure() {
	chmod +x configure || die
	econf $(use_enable test samples)
}

src_test() {
	cat > test.sh <<- EOFTEST
	LD_LIBRARY_PATH=${S}/lib samples/example1/example1 <<- EOF
	quit
	EOF
	EOFTEST
	sh ./test.sh || die "test failed"
}

src_install() {
	default
	dodoc Changes.txt
	use doc && dohtml -r docs/html/*
}
