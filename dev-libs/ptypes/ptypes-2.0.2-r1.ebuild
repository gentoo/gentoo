# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ptypes/ptypes-2.0.2-r1.ebuild,v 1.6 2014/08/10 20:39:04 slyfox Exp $

inherit eutils toolchain-funcs

DESCRIPTION="PTypes (C++ Portable Types Library), alternative to the STL including multithreading and networking"
HOMEPAGE="http://www.melikyan.com/ptypes/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-gcc41.patch"
	sed -i \
		-e 's/-O2/$(CXXFLAGS)/' \
		src/Makefile.common wshare/Makefile.common \
		|| die "sed failed"
}

src_compile() {
	if ! use debug ; then
		sed -i \
			-e 's/^\(DDEBUG\).*/\1=/' \
			src/Makefile.common wshare/Makefile.common \
			|| die "sed failed"
	fi
	emake CXX=$(tc-getCXX) CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dolib lib/* || die "Installing libraries"
	insinto /usr/include
	doins include/* || die "Installing headers"
	dohtml -r doc/* || die "Installing documentation"
}
