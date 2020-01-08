# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A C library implementing a suite of algorithms to factor large integers"
HOMEPAGE="https://sourceforge.net/projects/msieve/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/Msieve%20v${PV}/${PN}${PV/./}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zlib +ecm mpi"

DEPEND="
	ecm? ( sci-mathematics/gmp-ecm )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

src_prepare() {
	# TODO: Integrate ggnfs properly
	epatch \
		"${FILESDIR}"/${P}-reduce-printf.patch \
		"${FILESDIR}"/fix-version.patch \
		"${FILESDIR}"/fix-version2.patch
	sed -i -e 's/-march=k8//' Makefile 		|| die
	sed -i -e 's/CC =/#CC =/' Makefile 		|| die
	sed -i -e 's/CFLAGS =/CFLAGS +=/' Makefile 	|| die
	sed -i -e 's/LIBS += -lecm/LIBS += -lecm -lgomp/' Makefile || die
}

src_compile() {
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
	mkdir -p "${D}/usr/include/msieve"
	mkdir -p "${D}/usr/lib/"
	mkdir -p "${D}/usr/share/doc/${P}/"
	cp include/* "${D}/usr/include/msieve" || die "Failed to install"
	cp libmsieve.a "${D}/usr/lib/" || die "Failed to install"
	dobin msieve
	cp Readme* "${D}/usr/share/doc/${P}/" || die "Failed to install"
}
