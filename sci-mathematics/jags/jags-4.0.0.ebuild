# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils toolchain-funcs

MYP="JAGS-${PV}"

DESCRIPTION="Just Another Gibbs Sampler for Bayesian MCMC simulation"
HOMEPAGE="http://mcmc-jags.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/mcmc-jags/JAGS/4.x/Source/${MYP}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)"

S="${WORKDIR}/${MYP}"

src_configure() {
	local myeconfargs=(
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(usex doc docs "")
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc "${BUILD_DIR}"/doc/manual/*.pdf
}
