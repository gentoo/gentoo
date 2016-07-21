# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs java-pkg-opt-2 java-ant-2

MY_P=${PN}.${PV}

DESCRIPTION="Protein multiple-alignment-based sequence annealing"
HOMEPAGE="http://bio.math.berkeley.edu/amap/"
SRC_URI="http://baboon.math.berkeley.edu/${PN}/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java"

RDEPEND="java? ( >=virtual/jre-1.5 )"
DEPEND="java? ( >=virtual/jdk-1.5 )"

S=${WORKDIR}/${PN}-align

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-includes.patch
}

src_compile() {
	emake -C align CXX="$(tc-getCXX)" \
		OPT_CXXFLAGS="${CXXFLAGS}" || die "make failed"

	if use java; then
		pushd "${S}"/display
		eant -Ddisplay all || die
		popd
	fi
}

src_install() {
	dobin align/${PN} || die
	dodoc align/{README,PROBCONS.README} || die
	insinto /usr/share/${PN}/examples
	doins examples/* || die
	if use java; then
		java-pkg_newjar "${S}"/display/AmapDisplay.jar amapdisplay.jar
		java-pkg_dolauncher amapdisplay --jar amapdisplay.jar
	fi
}
