# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

MYPN="ColPack"

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
LICENSE="GPL-3 LGPL-3"
HOMEPAGE="http://cscapes.cs.purdue.edu/coloringpage/"
SRC_URI="https://github.com/CSCsw/${MYPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
IUSE="openmp static-libs"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] && use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
		ewarn "You are using gcc without OpenMP"
		die "Need an OpenMP capable compiler"
	fi
}

src_prepare() {
	default
	sed -e 's/-O3//' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp)
}

src_install() {
	default
	rm -rf "${ED}"/usr/examples
	use static-libs || prune_libtool_files --all
}
