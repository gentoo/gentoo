# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="${PN}_${PV}"
DESCRIPTION="A sequence assembler for very short reads"
HOMEPAGE="https://www.ebi.ac.uk/~zerbino/velvet/"
SRC_URI="https://www.ebi.ac.uk/~zerbino/velvet/${MY_P}.tgz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc openmp"

BDEPEND="
	doc? ( virtual/latex-base )
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			llvm-core/clang-runtime[openmp]
		)
	)
"

PATCHES=( "${FILESDIR}/${P}-incompatible-pointers.patch" )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	if ! use doc; then
		sed -i -e '/default :/ s/doc//' "${S}"/Makefile || die
	fi
	elog "Upstream recommends using -O3 in CFLAGS"
	echo
	elog "To adjust the MAXKMERLENGTH, CATEGORIES, BIGASSEMBLY, LONGSEQUENCES parameters"
	elog "as described in the PDF manual, please set the variables by prepending VELVET_ in"
	elog "front of it. For example VELVET_MAXKMERLENGTH, VELVET_CATEGORIES, ..."
	elog "Set them either in your environment or in /etc/portage/make.conf, then re-emerge"
	elog "the package. For example:"
	elog "  VELVET_MAXKMERLENGTH=NN emerge [options] velvet"

	if [[ $(tc-getCC) =~ gcc ]]; then
		local eopenmp=-fopenmp
	elif [[ $(tc-getCC) =~ icc ]]; then
		local eopenmp=-openmp
	else
		elog "Cannot detect compiler type so not setting openmp support"
	fi
	append-flags -fPIC ${eopenmp}
	append-ldflags ${eopenmp}

	tc-export CC

	MAKE_XOPTS=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		OPT="${CFLAGS}"
	)
	use openmp && MAKE_XOPTS+=( OPENMP=1 )
	[[ ! -z "${VELVET_MAXKMERLENGTH}" ]] && MAKE_XOPTS+=( MAXKMERLENGTH=${VELVET_MAXKMERLENGTH} )
	[[ ! -z "${VELVET_CATEGORIES}" ]] && MAKE_XOPTS+=( CATEGORIES=${VELVET_CATEGORIES} )
	[[ ! -z "${VELVET_BIGASSEMBLY}" ]] && MAKE_XOPTS+=( BIGASSEMBLY=${VELVET_BIGASSEMBLY} )
	[[ ! -z "${VELVET_LONGSEQUENCES}" ]] && MAKE_XOPTS+=( LONGSEQUENCES=${VELVET_LONGSEQUENCES} )
}

src_compile() {
	emake "${MAKE_XOPTS[@]}" -j1
	emake "${MAKE_XOPTS[@]}" -j1 color
}

src_test() {
	emake "${MAKE_XOPTS[@]}" -j1 test
}

src_install() {
	dobin velvet{g,h,g_de,h_de}
	insinto /usr/share/${PN}
	doins -r contrib
	dodoc Manual.pdf CREDITS.txt ChangeLog
}
