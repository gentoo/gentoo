# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO
# utilities.c:20:1: warning: ‘MPI_Attr_get’ is deprecated:
# MPI_Attr_get was deprecated in MPI-2.0; use MPI_Comm_get_attr instead [-Wdeprecated-declarations]

inherit toolchain-funcs flag-o-matic

MY_P="${PN}.${PV}"

DESCRIPTION="SParse Object Oriented Linear Equations Solver"
HOMEPAGE="http://www.netlib.org/linalg/spooles"

SRC_URI="http://www.netlib.org/linalg/${PN}/${MY_P}.tgz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE="mpi static-libs threads"
RESTRICT="test"

RDEPEND="
	mpi? (
		virtual/mpi
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-I2Ohash-64bit.patch"
	"${FILESDIR}/${P}-makefiles.patch"
	"${FILESDIR}/${P}-formats.patch"
	"${FILESDIR}/${P}-NULL-is-not-int.patch"
	"${FILESDIR}/${P}-printf-long.patch"
	"${FILESDIR}/${P}-include-stdio.h.patch"
)

make_shared_lib() {
	local soname="$(basename "${1%.a}").so.$(ver_cut 1)"

	einfo "Making ${soname}"

	${2:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${1}" -Wl,--no-whole-archive \
		-o $(dirname "${1}")/"${soname}" || return 1
}

src_prepare() {
	default_src_prepare

	find . -name makefile -exec \
		sed -i -e 's:make:$(MAKE):g' '{}' \;

	sed \
		-e "s/@CC@/$(tc-getCC)/" \
		-e "s/@AR@/$(tc-getAR)/" \
		-e "s/@RANLIB@/$(tc-getRANLIB)/" \
		"${FILESDIR}"/Make.inc.in > Make.inc || die
}

src_compile() {
	append-flags -fPIC

	emake lib

	if use threads; then
		emake -C MT lib
	fi

	if use mpi; then
		emake -C MPI CC="mpicc" lib
	fi

	make_shared_lib libspooles.a $(usev mpi "mpicc") || die "shared lib failed"

	if use static-libs; then
		filter-flags -fPIC

		emake clean
		emake lib

		if use threads; then
			emake -C MT lib
		fi

		if use mpi; then
			emake -C MPI CC="mpicc" lib
		fi
	fi
}

src_install() {
	dolib.so libspooles.so.2
	dosym libspooles.so.2 /usr/$(get_libdir)/libspooles.so

	if use static-libs; then
		dolib.a libspooles.a
	fi

	find . -name '*.h' -print0 | \
		xargs -0 -n1 --replace=headerfile install -D headerfile tmp/headerfile

	insinto /usr/include/${PN}

	doins -r tmp/*
}
