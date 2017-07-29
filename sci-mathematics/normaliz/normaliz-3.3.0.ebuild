# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs eutils

MYP="Normaliz-${PV}"

DESCRIPTION="Tool for computations in affine monoids and more"
HOMEPAGE="http://www.mathematik.uni-osnabrueck.de/normaliz/"
SRC_URI="https://github.com/Normaliz/Normaliz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="doc extras openmp static-libs"

# would be nice to package scip and cocoalib

RDEPEND="
	dev-libs/gmp:=[cxx]
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
# Only a boost header is needed -> not RDEPEND

S="${WORKDIR}/${MYP}"

pkg_setup() {
	use openmp && tc-check-openmp
}

src_prepare() {
	default
	eautoreconf
}

src_configure () {
	econf \
		$(use_enable openmp) \
		$(use_enable static-libs static)
}

src_test() {
	emake check
}

src_install() {
	default
	use static-libs || prune_libtool_files --all
	use doc && dodoc doc/Normaliz.pdf
	if use extras; then
		newdoc Singular/normaliz.pdf singular-normaliz.pdf
		insinto /usr/share/${PN}
		doins Singular/normaliz.lib
		doins Macaulay2/Normaliz.m2
	fi
}
