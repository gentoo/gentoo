# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="A C library implementing a suite of algorithms to factor large integers"
HOMEPAGE="https://sourceforge.net/projects/msieve/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/Msieve%20v${PV}/${PN}${PV/./}_src.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zlib +ecm mpi"

# some linking troubles with gwnum
DEPEND="
	ecm? ( sci-mathematics/gmp-ecm[-gwnum] )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# TODO: Integrate ggnfs properly
	eapply \
		"${FILESDIR}"/${PN}-1.51-reduce-printf.patch \
		"${FILESDIR}"/${PN}-1.53-fix-version.patch

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
	mkdir -p "${ED%/}/usr/include/msieve"
	mkdir -p "${ED%/}/usr/lib/"
	mkdir -p "${ED%/}/usr/share/doc/${P}/"
	cp include/* "${ED%/}/usr/include/msieve" || die "Failed to install"
	cp libmsieve.a "${ED%/}/usr/lib/" || die "Failed to install"
	dobin msieve || die "Failed to install"
	cp Readme* "${ED%/}/usr/share/doc/${P}/" || die "Failed to install"
}
