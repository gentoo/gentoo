# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs versionator flag-o-matic

MYP=${PN}.${PV}

DESCRIPTION="SParse Object Oriented Linear Equations Solver"
HOMEPAGE="http://www.netlib.org/linalg/spooles"
SRC_URI="http://www.netlib.org/linalg/${PN}/${MYP}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="mpi static-libs threads"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

make_shared_lib() {
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	einfo "Making ${soname}"
	${2:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${1}" -Wl,--no-whole-archive \
		-o $(dirname "${1}")/"${soname}" || return 1
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-I2Ohash-64bit.patch
	epatch "${FILESDIR}"/${P}-makefiles.patch
	epatch "${FILESDIR}"/${P}-formats.patch
	find . -name makefile -exec \
		sed -i -e 's:make:$(MAKE):g' '{}' \;
	sed -e "s/@CC@/$(tc-getCC)/" \
		-e "s/@AR@/$(tc-getAR)/" \
		-e "s/@RANLIB@/$(tc-getRANLIB)/" \
		"${FILESDIR}"/Make.inc.in > Make.inc || die
}

src_compile () {
	append-flags -fPIC
	emake lib
	use threads && emake -C MT lib
	use mpi && emake -C MPI CC=mpicc lib
	make_shared_lib libspooles.a $(use mpi && echo mpicc) || die "shared lib failed"
	if use static-libs; then
		filter-flags -fPIC
		emake clean
		emake lib
		use threads && emake -C MT lib
		use mpi && emake -C MPI CC=mpicc lib
	fi
}

src_install () {
	dolib.so libspooles.so.2
	dosym libspooles.so.2 /usr/$(get_libdir)/libspooles.so
	use static-libs && dolib.a libspooles.a
	find . -name '*.h' -print0 | \
		xargs -0 -n1 --replace=headerfile install -D headerfile tmp/headerfile
	insinto /usr/include/${PN}
	doins -r tmp/*
}
