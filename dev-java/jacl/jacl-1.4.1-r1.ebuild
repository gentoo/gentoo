# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${P//-}"

DESCRIPTION="Jacl is an implementation of Tcl written in Java"
HOMEPAGE="http://tcljava.sourceforge.net"
SRC_URI="mirror://sourceforge/tcljava/${MY_P}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

CDEPEND=">=dev-lang/tcl-8.4.5:*"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CRDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}

src_configure() {
	:
}

src_compile() {
	rm -rf src/{Test.java,empty,tests,janino} || die
	java-pkg-simple_src_compile
	mv src/jacl/tcl src/ || die
	java-pkg_addres "${PN}.jar" src/ -name "*.tcl"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher jaclsh --main tcl.lang.Shell
	dodoc README ChangeLog known_issues.txt || die
}
