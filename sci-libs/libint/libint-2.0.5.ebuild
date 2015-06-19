# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libint/libint-2.0.5.ebuild,v 1.1 2015/05/07 07:10:49 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2 toolchain-funcs versionator

MY_PV="$(replace_all_version_separators -)"

DESCRIPTION="Matrix elements (integrals) evaluation over Cartesian Gaussian functions"
HOMEPAGE="https://github.com/evaleev/libint"
SRC_URI="https://github.com/evaleev/libint/archive/release-2-0-5.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs doc"

S="${WORKDIR}/${PN}-release-${MY_PV}"

DEPEND="
	dev-libs/boost
	doc? (
		dev-texlive/texlive-latex
		dev-tex/latex2html
	)"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		--with-cxx=$(tc-getCXX)
		--with-cxx-optflags="${CXXFLAGS}"
		--with-cxxgen-optflags="${CXXFLAGS}"
		--with-cxxdepend=$(tc-getCXX)
		--with-ranlib=$(tc-getRANLIB)
		--with-ar=$(tc-getAR)
		--with-ld=$(tc-getLD)
	)
	autotools-utils_src_configure
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"

	use doc && emake html pdf
}

src_install() {
	einstall

	if use doc; then
		DOCS=( doc/progman/progman.pdf )
		HTML_DOCS=( doc/progman/progman/*.{html,png,css} )
		einstalldocs
	fi
}
