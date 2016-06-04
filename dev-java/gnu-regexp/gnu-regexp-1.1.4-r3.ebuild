# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="gnu.regexp-${PV}"

DESCRIPTION="GNU regular expression package for Java"
HOMEPAGE="https://savannah.gnu.org/projects/gnu-regexp"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

CDEPEND="dev-java/java-getopt:1"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

JAVA_SRC_DIR="src"

JAVA_GENTOO_CLASSPATH="java-getopt-1"

java_prepare() {
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" src -name "*.properties"
}
