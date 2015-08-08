# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils subversion toolchain-funcs

DESCRIPTION="A C library implementing a suite of algorithms to factor large integers"
HOMEPAGE="http://sourceforge.net/projects/msieve/"
#SRC_URI="mirror://sourceforge/${PN}/${PN}/Msieve%20v${PV}/${PN}${PV/./}src.tar.gz"
ESVN_REPO_URI="https://msieve.svn.sourceforge.net/svnroot/msieve"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="zlib +ecm mpi"

# some linking troubles with gwnum
DEPEND="
	ecm? ( sci-mathematics/gmp-ecm[-gwnum] )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

src_prepare() {
	cd trunk
	# TODO: Integrate ggnfs properly
	sed -i -e 's/-march=k8//' Makefile 		|| die
	sed -i -e 's/CC =/#CC =/' Makefile 		|| die
	sed -i -e 's/CFLAGS =/CFLAGS +=/' Makefile 	|| die
}

src_compile() {
	cd trunk
	use ecm && export "ECM=1"
	use mpi && export "MPI=1"
	use zlib && export "ZLIB=1"
	emake \
		CC=$(tc-getCC) \
		AR=$(tc-getAR) \
		OPT_FLAGS="${CFLAGS}" \
		all
}

src_install() {
	cd trunk
	mkdir -p "${D}/usr/include/msieve"
	mkdir -p "${D}/usr/lib/"
	mkdir -p "${D}/usr/share/doc/${P}/"
	cp include/* "${D}/usr/include/msieve" || die "Failed to install"
	cp libmsieve.a "${D}/usr/lib/" || die "Failed to install"
	dobin msieve || die "Failed to install"
	cp Readme* "${D}/usr/share/doc/${P}/" || die "Failed to install"
}
