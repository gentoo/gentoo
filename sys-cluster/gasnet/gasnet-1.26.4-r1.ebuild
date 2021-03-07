# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs multilib

MY_P="${PN^^[gasn]}-${PV}"
DESCRIPTION="Networking middleware for partitioned global address space (PGAS) language"
HOMEPAGE="https://gasnet.lbl.gov/"
SRC_URI="https://gasnet.lbl.gov/download/${MY_P}.tar.gz"

SOVER="${PV%%.*}"
LICENSE="BSD"
SLOT="0/${SOVER}"
KEYWORDS="~amd64"
IUSE="mpi static-libs threads"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

static_to_shared() {
	local libstatic="${1}"; shift
	local libname="${libstatic%.a}"
	libname="${libname##*/}"
	local soname="${libname}$(get_libname ${SOVER})"
	local libdir="${libstatic%/*}"

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

src_prepare() {
	find . \
		\( -name Makefile.am -or -name "*.mak" \) \
		-exec sed -i '/^docdir/s/^/#/' {} + || die
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable mpi) \
		$(use_enable threads pthreads) \
		CC="$(tc-getCC) ${CFLAGS} -fPIC" \
		MPI_CC="mpicc ${CFLAGS} -fPIC" \
		CXX="$(tc-getCXX) ${CFLAGS} -fPIC"
}

src_install() {
	local l libs
	default
	for l in "${ED}/usr/$(get_libdir)"/*.a; do
		libs=
		[[ $l = *mpi* ]] && libs+=" -lmpi"
		static_to_shared "${l}" ${libs}
	done
	use static-libs || rm -f "${ED}/usr/$(get_libdir)"/*.a || die
}
