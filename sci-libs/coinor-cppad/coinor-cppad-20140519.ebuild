# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-cppad/coinor-cppad-20140519.ebuild,v 1.1 2014/05/21 18:25:56 bicatali Exp $

EAPI=5

inherit autotools-utils multilib

MYP=cppad-${PV}

DESCRIPTION="COIN-OR C++ Algorithmic Differentiation"
HOMEPAGE="https://projects.coin-or.org/CppAD/"
SRC_URI="http://www.coin-or.org/download/source/CppAD/${MYP}.gpl.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	sci-libs/adolc:0=
	sci-libs/ipopt:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

S="${WORKDIR}/${MYP}"

src_configure() {
	local myeconfargs=( $(use doc Documentation) )
	autotools-utils_src_configure CXX_FLAGS="${CXXFLAGS}"
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		./build.sh doxygen || die
	fi
}

src_test() {
	autotools-utils_src_test check test
}

src_install() {
	use doc && HTML_DOC=( "${BUILD_DIR}"/doxydocs/html/. )
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r example/*
	fi
}
