# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs versionator

MYP="Normaliz-${PV}"

DESCRIPTION="Tool for computations in affine monoids and more"
HOMEPAGE="http://www.mathematik.uni-osnabrueck.de/normaliz/"
SRC_URI="https://github.com/Normaliz/Normaliz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc extras openmp"

RDEPEND="
	dev-libs/gmp[cxx]
"
DEPEND="${RDEPEND}
	doc? ( app-text/texlive )
	dev-libs/boost"
# Only a boost header is needed -> not RDEPEND

S=${WORKDIR}/${MYP}

src_prepare () {
	./bootstrap.sh || die
	default
}

src_configure () {
	if use openmp && ! tc-has-openmp ; then
		die "You requested openmp, but your toolchain does not support it."
	fi
	econf $(use_enable openmp)
}

src_install() {
	default
	if use doc ; then
		pushd doc
		pdflatex Normaliz || die
		pdflatex Normaliz || die
		dodoc "Normaliz.pdf"
		pdflatex NmzIntegrate || die
		pdflatex NmzIntegrate || die
		dodoc "NmzIntegrate.pdf"
		popd
	fi
	if use extras; then
		elog "You have selected to install extras which consist of Macaulay2"
		elog "and Singular packages. These have been installed into "
		elog "/usr/share/${PN}, and cannot be used without additional setup. Please refer"
		elog "to the homepages of the respective projects for additional information."
		elog "Note however, Gentoo's versions of Singular and Macaulay2 bring their own"
		elog "copies of these interface packages. Usually you don't need normaliz's versions."
		insinto "/usr/share/${PN}"
		doins Singular/normaliz.lib
		doins Macaulay2/Normaliz.m2
	fi
}
