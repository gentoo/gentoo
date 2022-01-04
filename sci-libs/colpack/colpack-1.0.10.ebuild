# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MYPN="ColPack"

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
HOMEPAGE="https://cscapes.cs.purdue.edu/coloringpage/"
SRC_URI="https://github.com/CSCsw/${MYPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="openmp"

S="${WORKDIR}/${MYPN}-${PV}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	sed -e 's/-O3//' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable openmp)
}

src_install() {
	default
	rm -rf "${ED}"/usr/examples
	find "${ED}" -name '*.la' -delete || die
}
