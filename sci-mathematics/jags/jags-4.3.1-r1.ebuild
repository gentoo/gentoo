# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool toolchain-funcs

MYP="JAGS-${PV}"

DESCRIPTION="Just Another Gibbs Sampler for Bayesian MCMC simulation"
HOMEPAGE="https://mcmc-jags.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/mcmc-jags/JAGS/$(ver_cut 1).x/Source/${MYP}.tar.gz"
S="${WORKDIR}/${MYP}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-libs/libltdl
	virtual/blas
	virtual/lapack
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)
"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_compile() {
	emake all $(usev doc docs)
}

src_install() {
	default
	use doc && dodoc doc/manual/*.pdf
	find "${ED}" -name '*.la' -delete || die
}
