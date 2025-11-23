# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib toolchain-funcs

MY_PN="Csdp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="COIN-OR C Library for Semi-Definite Programming"
HOMEPAGE="https://projects.coin-or.org/Csdp/"
SRC_URI="https://www.coin-or.org/download/source/${MY_PN}/${MY_P}.tgz -> ${P}.tar.gz"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples openmp"

RDEPEND="virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-6.2.0_toolchain-vars.patch
)

S="${WORKDIR}"/${MY_P}

_get_version_component_count() {
	local cnt=( $(ver_rs 1- ' ') )
	echo ${#cnt[@]} || die
}

static_to_shared() {
	local libstatic=${1}
	shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(ver_cut 1-2))
	local libdir=$(dirname ${libstatic})

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

		if [[ $(_get_version_component_count) -ge 1 ]] ; then
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(ver_cut 1)) || die
		fi

		ln -s ${soname} ${libdir}/${libname}$(get_libname) || die
	fi
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	append-cflags -DNOSHORTS -DUSEGETTIME -I../include

	if use openmp; then
		append-cflags -DUSEOPENMP

		if [[ $(tc-getCC) == *icc* ]]; then
			append-cflags -openmp
		else
			append-cflags -fopenmp
			append-ldflags -fopenmp
		fi
	fi

	use amd64 && append-cflags -DBIT64

	[[ $($(tc-getPKG_CONFIG) --libs blas) =~ atlas ]] && append-cflags -DUSEATLAS

	tc-export CC
}

src_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" -C lib
	local libs="$($(tc-getPKG_CONFIG) --libs blas lapack)" || die
	static_to_shared lib/libsdp.a ${libs}
	emake -C solver LIBS="${libs} -L../lib -lsdp -lm"
	emake -C theta LIBS="${libs} -L../lib -lsdp -lm"
}

src_test() {
	LD_LIBRARY_PATH="${S}/lib" emake -C test
}

src_install() {
	dobin solver/csdp theta/{theta,graphtoprob,complement,rand_graph}
	dolib.so lib/libsdp$(get_libname)*
	insinto /usr/include/${PN}
	doins include/*
	dodoc AUTHORS README
	use doc && dodoc doc/csdpuser.pdf
	if use examples; then
		docinto examples
		dodoc example/*
	fi
}
