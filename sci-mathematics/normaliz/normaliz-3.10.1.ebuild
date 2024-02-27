# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Tool for computations in affine monoids and more"
HOMEPAGE="https://www.normaliz.uni-osnabrueck.de/"
SRC_URI="https://github.com/Normaliz/Normaliz/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="doc extras nauty openmp"

RDEPEND="
	dev-libs/gmp:=[cxx(+)]
	nauty? ( sci-mathematics/nauty )
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
# Only a boost header is needed -> not RDEPEND

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	# Fix C standard compliance.
	default
	eautoreconf
}

src_configure() {
	# flint (and arb, which doesn't make an appearance in ./configure --help)
	# is somehow connected to e-antic, which we do not yet package. Likewise
	# we have no packages for cocoalib or hashlibrary.
	econf \
		$(use_enable openmp) \
		$(use_with nauty) \
		--without-cocoalib \
		--without-hashlibrary \
		--without-flint \
		--without-e-antic \
		--disable-static
}

src_compile() {
	# Clobber the default "AM_LDFLAGS = -Wl,-s" to avoid QA warnings
	# about pre-stripped binaries.
	emake AM_LDFLAGS=""
}

src_install() {
	default

	use doc && dodoc doc/Normaliz.pdf doc/NmzShortRef.pdf
	if use extras; then
		newdoc Singular/normaliz.pdf singular-normaliz.pdf
		insinto /usr/share/${PN}
		doins Singular/normaliz.lib
		doins Macaulay2/Normaliz.m2
	fi

	find "${ED}" -type f -name "*.la" -delete || die
}
