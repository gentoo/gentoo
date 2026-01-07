# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="gnu.regexp-${PV}"

DESCRIPTION="GNU regular expression package for Java"
HOMEPAGE="https://savannah.gnu.org/projects/gnu-regexp"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 ~arm64 ppc64 ~x64-macos ~x64-solaris"

CDEPEND="dev-java/java-getopt:1"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

JAVA_SRC_DIR="src"

JAVA_GENTOO_CLASSPATH="java-getopt-1"

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" src -name "*.properties"
}
