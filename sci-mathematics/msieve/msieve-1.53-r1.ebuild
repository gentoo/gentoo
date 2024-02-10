# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A C library implementing a suite of algorithms to factor large integers"
HOMEPAGE="https://sourceforge.net/projects/msieve/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/Msieve%20v${PV}/${PN}${PV/./}_src.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zlib +ecm mpi"

RDEPEND="
	ecm? ( sci-mathematics/gmp-ecm )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

PATCHES=(
	# TODO: Integrate ggnfs properly
	"${FILESDIR}"/${PN}-1.51-reduce-printf.patch
	"${FILESDIR}"/${PN}-1.53-fix-version.patch
	"${FILESDIR}"/${PN}-1.53-makefile.patch
)

src_configure() {
	tc-export AR CC RANLIB

	use ecm && export ECM=1

	if use mpi; then
		export MPI=1
		export CC=mpicc
	fi

	use zlib && export ZLIB=1
}

src_compile() {
	emake all
}

src_install() {
	dobin msieve

	insinto /usr/include/msieve
	doins -r include/.

	dolib.a libmsieve.a

	dodoc Readme*
}
